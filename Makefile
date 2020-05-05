# User settings
APP_NAME := rabbit_recipe
AWS_PROFILE := rabbit-recipe
AWS_REGION := ap-northeast-1
DOMAIN := rabbit-recipe.tech
ENV := dev
SEGMENT := 10

# Infrastructure
cfn_all: cfn_init cfn_backend cfn_frontend

cfn_init:

cfn_backend:

cfn_frontend:

# Backend
get:
	pushd backend; mix deps.get; popd

update:
	pushd backend; mix deps.update --all; popd

compile: get
	pushd backend; mix compile; popd

release: compile
	pushd backend; MIX_ENV=${ENV} mix distillery.release --env=${ENV}; popd

# Test
test_db:
	docker run -d --name mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=root -e MYSQL_DATABASE=rabbit_recipe_${ENV} mysql:5.6.47

# Develop (Local build)
clean: down
	- sh ./scripts/clean.sh

develop: down build up

build:
	APP_NAME=${APP_NAME} ENV=${ENV} docker-compose build

up:
	APP_NAME=${APP_NAME} ENV=${ENV} docker-compose up

down:
	docker-compose down
