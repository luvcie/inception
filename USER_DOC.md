# USER_DOC

User documentation for Inception.

## What is running

The stack runs 8 services:

| Service | What it does | URL |
|---------|-------------|-----|
| WordPress | The main website and blog | https://lucpardo.42.fr/ |
| WordPress admin | Administration panel for the site | https://lucpardo.42.fr/wp-admin/ |
| MariaDB | Database storing all WordPress data | internal only |
| Redis | Cache layer for WordPress (faster page loads) | internal only |
| FTP server | File access to the WordPress volume | ftp lucpardo.42.fr (port 21) |
| Static site | A simple HTML/CSS portfolio site | http://lucpardo.42.fr:8081/ |
| Adminer | Web UI for browsing the database | http://lucpardo.42.fr:8080/ |
| Portainer | Web UI for managing Docker containers | https://lucpardo.42.fr:9443/ |

## Before starting

You need to create `srcs/.env` manually. It is gitignored and not included in the repository. See `DEV_DOC.md` for the full list of required variables and how to fill them in. I would simply provide a `.env_example` file and tell you to edit it, but I don't trust the good faith of the evaluators of this school. :)

## Start and stop

From the root of the project on the VM:

```sh
make        # start everything
make down   # stop everything
```

## Accessing the services

The WordPress site is available at `https://lucpardo.42.fr/`. Your browser will show a certificate warning since the TLS certificate is self-signed. This is expected, you can safely click through it.

The WordPress admin panel is at `https://lucpardo.42.fr/wp-admin/`. Log in with the admin credentials from `srcs/.env` (`WP_ADMIN_USER` and `WP_ADMIN_PASSWORD`).

## Credentials

All credentials are defined by you when creating `srcs/.env`.

| Credential | Variable in .env |
|------------|-----------------|
| WordPress admin login | `WP_ADMIN_USER` / `WP_ADMIN_PASSWORD` |
| WordPress regular user | `WP_USER` / `WP_USER_PASSWORD` |
| MariaDB user | `MYSQL_USER` / `MYSQL_PASSWORD` |
| MariaDB root | `root` / `MYSQL_ROOT_PASSWORD` |
| FTP login | `FTP_USER` / `FTP_PASSWORD` |
| Portainer admin | set on first boot and stored in the portainer-data volume |

To log into Adminer, go to `http://lucpardo.42.fr:8080/`, select MySQL, and use the MariaDB credentials above with server `mariadb` and database `MYSQL_DATABASE`.

## Checking that everything is running

```sh
docker compose -f srcs/docker-compose.yml ps
```

All 8 containers should show as running. To check logs for a specific service:

```sh
docker compose -f srcs/docker-compose.yml logs <service-name>
```

Service names: `mariadb`, `wordpress`, `nginx`, `redis`, `ftp`, `static`, `adminer`, `portainer`.
