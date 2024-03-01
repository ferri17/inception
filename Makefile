GREEN=\033[1;32m
RED=\033[1;31m
BLUE=\033[1;34m
END=\033[0m

DOCKER_COMPOSE_FILE = srcs/docker-compose.yml

all:
	@echo "$(GREEN)Building and starting all containers: $(END)"
	docker compose -f $(DOCKER_COMPOSE_FILE) up --build

down:
	docker compose -f $(DOCKER_COMPOSE_FILE) down
clean:
	@if [ ! -z "$$(docker ps -aq)" ]; then \
		docker stop $$(docker ps -aq) > /dev/null; \
		docker rm $$(docker ps -aq) > /dev/null; \
	fi
	@if [ ! -z "$$(docker images -aq)" ]; then \
		docker rmi $$(docker images -aq) > /dev/null; \
	fi	
	@if [ ! -z "$$(docker volume ls -q)" ]; then \
		docker volume rm $$(docker volume ls -q) > /dev/null; \
	fi
	@echo "$(GREEN)Deleted all docker containers, volumes, and images succesfully$(END)"
memory:
	output_clean=$$(docker ps -aq)
#	output_clean="$output_clean + $$(docker images -aq)"
#	output_clean+=$$(docker volume ls -q)
	echo "output: $$output_clean"
test:
	if [ -z "$$(docker ps -aq)" ]; then \
		echo "empty"; \
	fi


.PHONY: all down clean
