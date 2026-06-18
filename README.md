*This project has been created as part of the 42 curriculum by lucpardo.*

# Inception

A Docker Compose infrastructure running NGINX, WordPress, and MariaDB inside a virtual machine, with bonus services for caching, ftp, and administration.

![42 Project](https://img.shields.io/badge/42-Project-blue)

## Description

Inception sets up a small multi-container infrastructure inside a virtual machine using Docker Compose. NGINX is the only entry point, serving WordPress over TLS on port 443. WordPress runs with php-fpm and stores its data in MariaDB. Each service is built from Alpine 3.21 images, no pre-built images are used.

The bonus part adds Redis (object cache for WordPress), vsftpd (FTP access to the WordPress volume), a static HTML/CSS site, Adminer (database management UI), and for the service of choice I chose Portainer :) (Docker management UI).

### Project description

**Virtual Machines vs Docker.** A VM virtualizes an entire OS including its own kernel. Docker containers share the host kernel and isolate only the process environment using namespaces and cgroups, making them much lighter. 

In this project Docker runs inside a VM, and Docker is the containerization layer within it. 

(I guess this is why it's called inception. :P)

**Secrets vs Environment Variables.** Environment variables are readable by any process inside the container via `/proc/self/environ` (/environ is a file containing the current process's environment variables, which would be insecure!) So Docker secrets mount sensitive values as files in tmpfs memory, never exposed as environment variables. tmpfs is a service that lives in RAM. Docker uses this by default.

This project uses a `.env` file, which has been gitignored, the .env file is loaded by Docker Compose using `env_file:` which injects the values as env vars into each container. 

**Docker Network vs Host Network.** `network: host` removes all network isolation and exposes the container directly on the host interfaces. A custom bridge network (`inception`) keeps containers isolated, reachable only by service name from within the network. Only NGINX exposes a port to the outside (443).

The custom brdige network was made in docker-compose.yml

```
networks:
	inception:
		driver: bridge
```

And every service has:

```
networks:
	- inception
```

**Docker Volumes vs Bind Mounts.** Named Docker volumes are managed by Docker and stored in `/var/lib/docker/volumes/`. Bind mounts map a specific host path directly into the container. This project uses named volumes with `driver_opts` (`type: none`, `o: bind`, `device: /home/lucpardo/data/...`) to satisfy the named volume requirement while keeping data at a predictable host path.

## Instructions

### Prerequisites

- Docker and Docker Compose installed on the VM
- Add the VM IP to `/etc/hosts` on the client machine: `<VM_IP> lucpardo.42.fr`
- Create the data directories on the VM:
  ```sh
  mkdir -p /home/lucpardo/data/db /home/lucpardo/data/wordpress
  ```
- Create `srcs/.env` with the required variables (see `DEV_DOC.md`)

### Build and run

```sh
make        # build all images and start all containers
make down   # stop and remove containers
make clean  # remove containers and images
make fclean # remove containers, images, and volumes
make re     # fclean followed by make
```

### Services

| Service | URL | Port |
|---------|-----|------|
| WordPress | https://lucpardo.42.fr/ | 443 |
| WordPress admin | https://lucpardo.42.fr/wp-admin/ | 443 |
| Adminer | http://lucpardo.42.fr:8080/ | 8080 |
| Static site | http://lucpardo.42.fr:8081/ | 8081 |
| Portainer | https://lucpardo.42.fr:9443/ | 9443 |
| FTP | ftp lucpardo.42.fr | 21 |

## Resources

- Docker documentation: https://docs.docker.com/
- Docker Compose reference: https://docs.docker.com/compose/compose-file/
- NGINX documentation: https://nginx.org/en/docs/
- vsftpd manual: https://security.appspot.com/vsftpd/vsftpd_conf.html
- WP-CLI commands: https://developer.wordpress.org/cli/commands/
- Redis Object Cache plugin: https://wordpress.org/plugins/redis-cache/
- Adminer: https://www.adminer.org/
- Portainer CE documentation: https://docs.portainer.io/
- Alpine Linux packages: https://pkgs.alpinelinux.org/

AI was not used in this project. Most of the knowledge applied here comes from years of running a home server and a personal interest in self-hosting, so the concepts around Docker, networking, and service configuration were already familiar. Official documentation were consulted for specifics.
