GREEN=\033[1;32m
RED=\033[1;31m
BLUE=\033[1;34m
END=\033[0m

DOCKER_COMPOSE_FILE = srcs/docker-compose.yml

all:
	echo "$(GREEN)Building and starting all containers: $(END)"
	docker compose -f $(DOCKER_COMPOSE_FILE) up --build

down:
	docker compose -f $(DOCKER_COMPOSE_FILE) down
clean:
	echo "$(BLUE)Cleaning containers and volumes: $(END)"
	docker stop $$(docker ps -aq) > /dev/null 2>&1
	docker rm $$(docker ps -aq) > /dev/null 2>&1
	docker rmi $$(docker images -qa) > /dev/null 2>&1
	docker volume rm $$(docker volume ls -q) > /dev/null 2>&1
	output_clean=$$(docker ps -aq)
#	output_clean+=$$(docker images -aq)
#	output_clean+=$$(docker volume ls -q)
	echo "output: $$output_clean"

.PHONY: all down clean
