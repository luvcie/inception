DATA_DIR = /home/lucpardo/data

all: up

up:
	mkdir -p $(DATA_DIR)/db $(DATA_DIR)/wordpress
	docker compose -f srcs/docker-compose.yml --env-file srcs/.env up -d --build

down:
	docker compose -f srcs/docker-compose.yml --env-file srcs/.env down

stop:
	docker compose -f srcs/docker-compose.yml --env-file srcs/.env stop

start:
	docker compose -f srcs/docker-compose.yml --env-file srcs/.env start

clean: down
	docker system prune -f

fclean: clean
	docker volume rm $$(docker volume ls -q) 2>/dev/null || true
	sudo rm -rf $(DATA_DIR)

re: fclean all

.PHONY: all up down stop start clean fclean re
