# DEV_DOC

Developer documentation for Inception

## Environment setup

### Prerequisites

- A Linux virtual machine with Docker and Docker Compose installed.

  (It doesn't need to be in a VM, but the school subject makes it a requirement.)

### Data directories

The volumes for MariaDB and WordPress are bind-mounted to the host filesystem, so the directories need to exist before running the stack:

```sh
mkdir -p /home/lucpardo/data/db /home/lucpardo/data/wordpress
```

### Configuration file

Create `srcs/.env` at the root of the `srcs/` folder. It is gitignored and must be created manually. Required variables:

```sh
DOMAIN_NAME=lucpardo.42.fr   # or your own login

# MariaDB
MYSQL_DATABASE=
MYSQL_USER=
MYSQL_PASSWORD=
MYSQL_ROOT_PASSWORD=

# WordPress
WP_ADMIN_USER=     # must not contain "admin" or "Admin"
WP_ADMIN_PASSWORD=
WP_ADMIN_EMAIL=
WP_USER=
WP_USER_PASSWORD=
WP_USER_EMAIL=

# FTP
FTP_USER=
FTP_PASSWORD=
FTP_PASV_ADDRESS=  # the VM's IP address (e.g. 172.16.38.128)
```

### /etc/hosts

Find the VM's IP

```sh
ip a
```

Look for the ip on the interface connected to the host-only/NAT network, usually eth0 on vmware.

then add it to `/etc/hosts`:

```
<VM_IP> lucpardo.42.fr
```

On NixOS this is done declaratively via `networking.extraHosts` in `configuration.nix` since `/etc/hosts` is read-only. 

## Build and launch

```sh
make        # build all images and start all containers
make down   # stop and remove containers
make clean  # remove containers and images
make fclean # remove containers, images, and volumes
make re     # fclean followed by make
```

`make` runs `docker compose -f srcs/docker-compose.yml --env-file srcs/.env up -d --build`. All images are built from scratch from Alpine 3.21, nothing is pulled from Docker Hub.

The first boot takes longer because WordPress is downloaded and installed via WP-CLI, and MariaDB initializes the database, and the Portainer binary (~100) is downloaded from github releases. Next boots are fast since Docker caches the layers and the data already exists in the volumes.

## Managing containers

```sh
docker compose -f srcs/docker-compose.yml ps           # list 
running containers and their status
docker compose -f srcs/docker-compose.yml logs <name>  # view logs for a service
docker compose -f srcs/docker-compose.yml logs -f      # follow logs for all services
docker exec -it <name> sh                              # open a shell inside a container
docker exec wordpress wp <command> --allow-root --path=/var/www/html  # run wp-cli commands
```

## Managing volumes

```sh
docker volume ls                    # list all volumes
docker volume inspect <name>        # inspect a volume (shows the host path)
```

The volumes defined in `docker-compose.yml` and where their data actually lives:

| Volume | Host path | Contents |
|--------|-----------|----------|
| `wp-db` | `/home/lucpardo/data/db` | MariaDB database files |
| `wp-files` | `/home/lucpardo/data/wordpress` | WordPress core, plugins, uploads |
| `portainer-data` | Docker-managed (`/var/lib/docker/volumes/`) | Portainer settings and admin account |

## Data persistence

`wp-db` and `wp-files` are named volumes configured as bind mounts (`type: none`, `o: bind`), meaning the data lives at the host paths above. It survives `docker compose down`, container removal, and even `docker system prune --volumes` because the data is on the host filesystem, not inside Docker's volume storage.

`portainer-data` is a standard Docker-managed volume. It survives `docker compose down` but would be wiped by `docker volume rm srcs_portainer-data` or `docker system prune --volumes`.

To fully reset the stack and start from scratch:

```sh
make fclean
sudo rm -rf /home/lucpardo/data/db /home/lucpardo/data/wordpress
mkdir -p /home/lucpardo/data/db /home/lucpardo/data/wordpress
make
```
