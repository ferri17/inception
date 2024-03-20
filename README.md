<p align="center">
	<img alt="GitHub Repo stars" src="https://img.shields.io/github/stars/ferri17/inception?color=yellow" />
	<img alt="GitHub top language" src="https://img.shields.io/github/languages/top/ferri17/inception" />
	<img alt="GitHub code size in bytes" src="https://img.shields.io/github/languages/code-size/ferri17/inception?color=red" />
	<img alt="GitHub last commit (by committer)" src="https://img.shields.io/github/last-commit/ferri17/inception" />
	<img alt="Linux compatibility" src="https://img.shields.io/badge/-Linux-grey?logo=linux" />
</p>

<h3 align="center">Inception 42 school project</h3>

  <p align="center">
    This project consists in setting a small docker infrastructure composed of 3 services, a local wordpress installation, a Mysql(mariaDB) database to support the website, and to finish an nginx server to manage requests to the website.
    <br />
  </p>
</div>

<!-- ABOUT THE PROJECT -->
## About The Project
<img width="900" alt="Screenshot 2024-03-20 at 01 05 55" src="https://github.com/ferri17/inception/assets/19575860/d9e46f87-fa55-4a17-936c-8f856f660de2">


The system follows these rules:

<ul>
  <li>A Docker container contains NGINX with TLSv1.3.</li>
  <li>A Docker container contains WordPress + php-fpm.</li>
  <li>A Docker container contains MariaDB.</li>
  <li>2 volumes: 1 stores website files (wordpress), the other one stores the database(mariaDB).</li>
  <li>A Docker network comunicates all the containers between each other.</li>
  <li>The system can only be accessed through port 443 (https) on nginx container.</li>
</ul>

## Makefile
I created a makefile to quickly build and clean the setup. It allows to build(make), stop the services(make down), and fully clean - docker + local storage - (make clean).

```Makefile
GREEN=\033[1;32m
RED=\033[1;31m
BLUE=\033[1;34m
END=\033[0m

DOCKER_COMPOSE_FILE = srcs/docker-compose.yml

all:
	@echo "$(GREEN)Building and starting all containers: $(END)"
	mkdir -p /home/$(USER)/data/wordpress
	mkdir -p /home/$(USER)/data/mariadb
	docker compose -f $(DOCKER_COMPOSE_FILE) up --detach --build

down:
	docker compose -f $(DOCKER_COMPOSE_FILE) down
clean:
	@if [ ! -z "$$(docker ps -aq)" ]; then \
		docker stop $$(docker ps -aq); \
		docker rm $$(docker ps -aq); \
	fi
	@if [ ! -z "$$(docker images -aq)" ]; then \
		docker rmi $$(docker images -aq); \
	fi	
	@if [ ! -z "$$(docker volume ls -q)" ]; then \
		docker volume rm $$(docker volume ls -q); \
	fi
	@if [ ! -z "$$(docker network ls -q --filter type=custom)" ]; then \
		docker network rm $$(docker network ls -q --filter type=custom); \
	fi
	rm -rf /home/$(USER)/data/wordpress
	rm -rf /home/$(USER)/data/mariadb
	@echo "$(GREEN)Deleted all docker containers, volumes, networks, and images succesfully$(END)"

re: clean all

.PHONY: all down clean
```
## docker-compose.yml
```YAML
services:

  nginx:
    depends_on:
      - wordpress
    container_name: nginx
    build: requirements/nginx/
    image: nginx
    volumes:
      - wordpress_data:/var/www/html
    networks:
      - fbosch_network
    ports:
      - "443:443"
    restart: always

  wordpress:
    depends_on:
      - mariadb
    container_name: wordpress
    build: requirements/wordpress
    image: wordpress
    volumes:
      - wordpress_data:/var/www/html
    networks:
      - fbosch_network
    env_file:
      - .env
    restart: always

  mariadb:
    container_name: mariadb
    build: requirements/mariadb
    image: mariadb
    volumes:
      - mariadb_data:/var/lib/mysql
    networks:
      - fbosch_network
    env_file:
      - .env
    restart: always


volumes:

  wordpress_data:
    driver: local
    driver_opts:
      device: "/home/${USER}/data/wordpress"
      o: bind
      type: none
  
  mariadb_data:
    driver: local
    driver_opts:
      device: "/home/${USER}/data/mariadb"
      o: bind
      type: none


networks:
  fbosch_network:
    name: fbosch_network
    driver: bridge
```
<!---
Here is an example of a simple scene:
```
0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
0  0 10 10  0  0 10 10  0  0  0 10 10 10 10 10  0  0  0
0  0 10 10  0  0 10 10  0  0  0  0  0  0  0 10 10  0  0
0  0 10 10  0  0 10 10  0  0  0  0  0  0  0 10 10  0  0
0  0 10 10 10 10 10 10  0  0  0  0 10 10 10 10  0  0  0
0  0  0 10 10 10 10 10  0  0  0 10 10  0  0  0  0  0  0
0  0  0  0  0  0 10 10  0  0  0 10 10  0  0  0  0  0  0
0  0  0  0  0  0 10 10  0  0  0 10 10 10 10 10 10  0  0
0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
```
Each number represents a point in space:
* The horizontal position corresponds to its axis.
* The vertical position corresponds to its ordinate.
* The value corresponds to its altitude.
-->
<!-- GETTING STARTED 
## Getting Started
In order to run the program first clone the repository:
```bash
git clone git@github.com:ferri17/FdF.git
```
Open the folder:
```bash
cd FdF/
```
Compile the program:
```bash
make
```
Run the program with a valid map as argument(test maps can be found in /maps)
```bash
./fdf maps/42.fdf
```
-->

<!-- Controls 
## Controls
| Action                          | Key                      |
| :---                          | :----:                     |
| Mouse right click + drag      | Move map                   |
| Mouse left click + drag       | Rotate map                 |
| Lock rotation axis            | Hold X,Y,Z while rotating  |
| Color themes                  | 1, 2, 3                    |
| Change map heights            | N,M                        |
| Edge/Vertex mode              | G                          |
| Snap rotation                 | Hold H while rotating      |
| Isometric/Paralel projection  | I,P                        |
-->
<!-- Gallery 
## Gallery
<img width="1400" alt="Screen Shot 2023-08-10 at 3 30 30 PM" src="https://github.com/ferri17/FdF/assets/19575860/d131a52b-1bb3-4bdd-ba8a-9dfb42620446">
<img width="1396" alt="Screen Shot 2023-08-10 at 5 38 26 PM" src="https://github.com/ferri17/FdF/assets/19575860/ae64c1b0-6fe0-4f4a-8e3d-833ed7cfa393">
<img width="1397" alt="Screen Shot 2023-08-10 at 5 37 03 PM" src="https://github.com/ferri17/FdF/assets/19575860/e621e9ee-2ea8-4eaa-a51c-92b53e6e87c6">
-->
<!-- Resources
## Resources

**Minilibx**

Really good guides to start using minilibx functions.
* https://gontjarow.github.io/MiniLibX/mlx-tutorial-create-image.html
* https://harm-smits.github.io/42docs/libs/minilibx/images.html

**How to draw a line in a pixel map**
* https://en.wikipedia.org/wiki/Bresenham%27s_line_algorithm

**How to represent a 3D figure in a 2D space**
* https://www.youtube.com/watch?v=p4Iz0XJY-Qk
* https://en.wikipedia.org/wiki/Rotation_matrix
* https://clintbellanger.net/articles/isometric_math/
  
**Gradients**

Best walkthrough to understand how to calculate a gradient between 2 points
* https://dev.to/freerangepixels/a-probably-terrible-way-to-render-gradients-1p3n
  
**Virtual keys macOS**
* https://stackoverflow.com/questions/3202629/where-can-i-find-a-list-of-mac-virtual-key-codes

**Clipping lines to optimise render with Cohen-Sutherland algorithm**
* https://www.geeksforgeeks.org/line-clipping-set-1-cohen-sutherland-algorithm/

-->
