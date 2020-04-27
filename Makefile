clean: down
	- docker rm --force $(docker ps -a -q)
	- docker rmi --force $(docker images | grep none | awk '{print $3}')

build:
	docker-compose build

up:
	docker-compose up

down:
	docker-compose down
