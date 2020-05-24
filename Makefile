APP_NAME := rabbit_recipe
AWS_PROFILE := rabbit
AWS_REGION := ap-northeast-1
AWS_ACCOUNTID = $(shell aws sts get-caller-identity --profile $(AWS_PROFILE) | jq -r .Account)
DOMAIN := rabbit-recipe.tech
ENV := dev
SEGMENT := 10

.PHONY: init

# Setting
init:
	# Install Elixir, Erlang, Node.js
	asdf install
	# Clone git submodule
	git submodule update -i

# Infrastructure
# Shell か何かでコンパクトにしたいが、とりあえずここにベタ書きする
cfn_all: cfn_init cfn_backend cfn_frontend

cfn_init: cfn_init_route53 cfn_init_acm cfn_init_s3 cfn_init_vpc cfn_init_ecr
cfn_backend: cfn_backend_rds
cfn_frontend: cfn_frontend_ecs_cluster cfn_frontend_ecs_fargate cfn_frontend_cloudfront
cfn_deploy: cfn_deploy_pipeline

cfn_update: cfn_backend_rds_update cfn_frontend_ecs_fargate_update

cfn_init_route53:
	# Create Route53 hostedzones
	aws cloudformation create-stack --profile ${AWS_PROFILE} --region us-east-1 \
		--stack-name ${AWS_PROFILE}-route53 \
		--template-body file://infrastructure/init/route53.yml \
		--parameters \
			ParameterKey=ProjectName,ParameterValue=${AWS_PROFILE} \
			ParameterKey=DomainName,ParameterValue=${DOMAIN} \
			ParameterKey=Logging,ParameterValue=true
	aws cloudformation wait stack-create-complete --profile ${AWS_PROFILE} --region us-east-1 \
		--stack-name ${AWS_PROFILE}-route53

cfn_init_acm:
	# Create ACM
	# us-east-1 for cloudfront
	aws cloudformation create-stack --profile ${AWS_PROFILE} --region us-east-1 \
		--stack-name ${AWS_PROFILE}-acm \
		--template-body file://infrastructure/init/acm.yml \
		--parameters \
			ParameterKey=ProjectName,ParameterValue=${AWS_PROFILE} \
			ParameterKey=DomainName,ParameterValue=${DOMAIN}
	aws cloudformation create-stack --profile ${AWS_PROFILE} --region ${AWS_REGION} \
		--stack-name ${AWS_PROFILE}-acm \
		--template-body file://infrastructure/init/acm.yml \
		--parameters \
			ParameterKey=ProjectName,ParameterValue=${AWS_PROFILE} \
			ParameterKey=DomainName,ParameterValue=${DOMAIN}
	aws cloudformation wait stack-create-complete --profile ${AWS_PROFILE} --region ${AWS_REGION} \
		--stack-name ${AWS_PROFILE}-acm

cfn_init_s3:
	# Create S3 Bucket
	aws cloudformation create-stack --profile ${AWS_PROFILE} --region ${AWS_REGION} \
		--stack-name ${AWS_PROFILE}-${ENV}-s3-deploy \
		--template-body file://infrastructure/init/s3.yml \
		--parameters \
			ParameterKey=ProjectName,ParameterValue=${AWS_PROFILE} \
			ParameterKey=Env,ParameterValue=${ENV} \
			ParameterKey=Role,ParameterValue=deploy \
			ParameterKey=Versioning,ParameterValue=true
	aws cloudformation create-stack --profile ${AWS_PROFILE} --region ${AWS_REGION} \
		--stack-name ${AWS_PROFILE}-${ENV}-s3-log \
		--template-body file://infrastructure/init/s3.yml \
		--parameters \
			ParameterKey=ProjectName,ParameterValue=${AWS_PROFILE} \
			ParameterKey=Env,ParameterValue=${ENV} \
			ParameterKey=Role,ParameterValue=log \
			ParameterKey=Logging,ParameterValue=true
	aws cloudformation wait stack-create-complete --profile ${AWS_PROFILE} --region ${AWS_REGION} \
		--stack-name ${AWS_PROFILE}-${ENV}-s3-log

cfn_init_vpc:
	# Create VPC
	aws cloudformation create-stack --profile ${AWS_PROFILE} --region ${AWS_REGION} \
		--stack-name ${AWS_PROFILE}-${ENV}-vpc \
		--template-body file://infrastructure/init/vpc.yml \
		--capabilities CAPABILITY_NAMED_IAM \
		--parameters \
			ParameterKey=ProjectName,ParameterValue=${AWS_PROFILE} \
			ParameterKey=Env,ParameterValue=${ENV} \
			ParameterKey=Segment,ParameterValue=1 \
			ParameterKey=Logging,ParameterValue=true
	aws cloudformation wait stack-create-complete --profile ${AWS_PROFILE} --region ${AWS_REGION} \
		--stack-name ${AWS_PROFILE}-${ENV}-vpc

cfn_init_ecr:
	# Create ecr repository
	aws cloudformation create-stack --profile ${AWS_PROFILE} --region ${AWS_REGION} \
		--stack-name ${AWS_PROFILE}-${ENV}-ecr-proxy \
		--template-body file://infrastructure/init/ecr.yml \
		--parameters \
			ParameterKey=ProjectName,ParameterValue=${AWS_PROFILE} \
			ParameterKey=Env,ParameterValue=${ENV} \
			ParameterKey=Role,ParameterValue=proxy
	aws cloudformation create-stack --profile ${AWS_PROFILE} --region ${AWS_REGION} \
		--stack-name ${AWS_PROFILE}-${ENV}-ecr-api \
		--template-body file://infrastructure/init/ecr.yml \
		--parameters \
			ParameterKey=ProjectName,ParameterValue=${AWS_PROFILE} \
			ParameterKey=Env,ParameterValue=${ENV} \
			ParameterKey=Role,ParameterValue=api
	aws cloudformation wait stack-create-complete --profile ${AWS_PROFILE} --region ${AWS_REGION} \
		--stack-name ${AWS_PROFILE}-${ENV}-ecr-api

cfn_backend_rds:
	# Create RDS
	aws cloudformation create-stack --profile ${AWS_PROFILE} --region ${AWS_REGION} \
		--stack-name ${AWS_PROFILE}-${ENV}-rds-api \
		--template-body file://infrastructure/backend/serverless-aurora.yml \
		--parameters \
			ParameterKey=ProjectName,ParameterValue=${AWS_PROFILE} \
			ParameterKey=Env,ParameterValue=${ENV} \
			ParameterKey=Role,ParameterValue=api \
			ParameterKey=DatabaseName,ParameterValue=${APP_NAME}_${ENV} \
			ParameterKey=MasterUsername,ParameterValue=admin \
			ParameterKey=MasterUserPassword,ParameterValue='$(shell mkpasswd -l 16 -s 0)'
	aws cloudformation wait stack-create-complete --profile ${AWS_PROFILE} --region ${AWS_REGION} \
		--stack-name ${AWS_PROFILE}-${ENV}-rds-api

cfn_backend_rds_update:
	# Create changesets and update(Deploy) RDS
	aws cloudformation deploy --profile ${AWS_PROFILE} --region ${AWS_REGION} \
		--stack-name ${AWS_PROFILE}-${ENV}-rds-api \
		--template-file ./infrastructure/backend/serverless-aurora.yml

cfn_frontend_ecs_cluster:
	# Create ECS Cluster
	aws cloudformation create-stack --profile ${AWS_PROFILE} --region ${AWS_REGION} \
		--stack-name ${AWS_PROFILE}-${ENV}-ecs-cluster \
		--template-body file://infrastructure/frontend/ecs-cluster.yml \
		--parameters \
			ParameterKey=ProjectName,ParameterValue=${AWS_PROFILE} \
			ParameterKey=Env,ParameterValue=${ENV} \
			ParameterKey=Role,ParameterValue=api
	aws cloudformation wait stack-create-complete --profile ${AWS_PROFILE} --region ${AWS_REGION} \
		--stack-name ${AWS_PROFILE}-${ENV}-ecs-cluster

cfn_frontend_ecs_fargate:
	# Create ECS Fargate
	aws cloudformation create-stack --profile ${AWS_PROFILE} --region ${AWS_REGION} \
		--stack-name ${AWS_PROFILE}-${ENV}-ecs-api \
		--template-body file://infrastructure/frontend/ecs-fargate.yml \
		--capabilities CAPABILITY_NAMED_IAM \
		--parameters \
			ParameterKey=ProjectName,ParameterValue=${AWS_PROFILE} \
			ParameterKey=Env,ParameterValue=${ENV} \
			ParameterKey=Role,ParameterValue=api \
			ParameterKey=Port,ParameterValue=4000 \
			ParameterKey=HealthCheckPort,ParameterValue=4000 \
			ParameterKey=Command,ParameterValue='env && /app/_build/${ENV}/rel/${APP_NAME}/bin/${APP_NAME} foreground' \
			ParameterKey=DomainName,ParameterValue=${DOMAIN} \
			ParameterKey=Logging,ParameterValue=true
	aws cloudformation wait stack-create-complete --profile ${AWS_PROFILE} --region ${AWS_REGION} \
		--stack-name ${AWS_PROFILE}-${ENV}-ecs-api

cfn_frontend_ecs_fargate_update:
	# Create changesets and update(Deploy) ECS Fargate
	aws cloudformation deploy --profile ${AWS_PROFILE} --region ${AWS_REGION} \
		--stack-name ${AWS_PROFILE}-${ENV}-ecs-api \
		--template-file ./infrastructure/frontend/ecs-fargate.yml \
		--capabilities CAPABILITY_NAMED_IAM

cfn_frontend_cloudfront:
	# Create Cloudfront
	aws cloudformation create-stack --profile ${AWS_PROFILE} --region ${AWS_REGION} \
		--stack-name ${AWS_PROFILE}-${ENV}-cf-static \
		--template-body file://infrastructure/frontend/cloudfront.yml \
		--parameters \
			ParameterKey=ProjectName,ParameterValue=${AWS_PROFILE} \
			ParameterKey=Env,ParameterValue=${ENV} \
			ParameterKey=Role,ParameterValue=app \
			ParameterKey=OriginAlb,ParameterValue=true \
			ParameterKey=CertificateArn,ParameterValue='$(shell aws acm list-certificates --profile ${AWS_PROFILE} --region us-east-1 | jq -r '.CertificateSummaryList[] | select(.DomainName | match("($(DOMAIN))")) | .CertificateArn' )' \
			ParameterKey=DomainName,ParameterValue=${DOMAIN} \
			ParameterKey=Logging,ParameterValue=true
	aws cloudformation wait stack-create-complete --profile ${AWS_PROFILE} --region ${AWS_REGION} \
		--stack-name ${AWS_PROFILE}-${ENV}-cf-static

cfn_deploy_pipeline:
	# Create CodePipeline
	aws cloudformation create-stack --profile ${AWS_PROFILE} --region ${AWS_REGION} \
		--stack-name ${AWS_PROFILE}-${ENV}-deploy-api \
		--template-body file://infrastructure/deploy/codepipeline.yml \
		--capabilities CAPABILITY_NAMED_IAM \
		--parameters \
			ParameterKey=ProjectName,ParameterValue=${AWS_PROFILE} \
			ParameterKey=Env,ParameterValue=${ENV} \
			ParameterKey=Role,ParameterValue=api
	aws cloudformation wait stack-create-complete --profile ${AWS_PROFILE} --region ${AWS_REGION} \
		--stack-name ${AWS_PROFILE}-${ENV}-deploy-api

# Deployment
deploy_pipeline_json:
	sh ./scripts/make_json.sh ${AWS_ACCOUNTID} ${AWS_REGION} ${AWS_PROFILE} ${ENV} api
	zip imagedefinitions_api.json.zip imagedefinitions_api.json
	aws s3 cp --profile ${AWS_PROFILE} --region ${AWS_REGION} \
		./imagedefinitions_api.json.zip s3://${AWS_PROFILE}-${ENV}-deploy/

deploy_frontend: frontend_release

deploy_backend: docker_push

# Push docker images to ECR
docker_build:
	APP_NAME=${APP_NAME} \
		ENV=${ENV} \
			MASTER_USERNAME=$(shell aws ssm get-parameter --profile ${AWS_PROFILE} --region ${AWS_REGION} --name ${AWS_PROFILE}-${ENV}-api-MasterUsername | jq -r .Parameter.Value) \
			MASTER_USERPASSWORD=$(shell aws ssm get-parameter --profile ${AWS_PROFILE} --region ${AWS_REGION} --name ${AWS_PROFILE}-${ENV}-api-MasterUserPassword | jq -r .Parameter.Value) \
			MYSQL_HOSTNAME=$(shell aws ssm get-parameter --profile ${AWS_PROFILE} --region ${AWS_REGION} --name ${AWS_PROFILE}-${ENV}-api-MysqlHostname | jq -r .Parameter.Value) \
		docker-compose build

docker_login:
	aws ecr get-login-password --profile ${AWS_PROFILE} --region ${AWS_REGION} \
		| docker login --username AWS --password-stdin ${AWS_ACCOUNTID}.dkr.ecr.${AWS_REGION}.amazonaws.com

docker_tag: docker_build
	docker tag $(shell basename $(shell pwd))_proxy:latest ${AWS_ACCOUNTID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${AWS_PROFILE}-${ENV}/proxy:latest
	docker tag $(shell basename $(shell pwd))_api:latest ${AWS_ACCOUNTID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${AWS_PROFILE}-${ENV}/api:latest

docker_push: docker_login docker_tag
	docker push ${AWS_ACCOUNTID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${AWS_PROFILE}-${ENV}/proxy:latest
	docker push ${AWS_ACCOUNTID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${AWS_PROFILE}-${ENV}/api:latest

# Frontend package
frontend_build:
	pushd frontend; yarn build; popd

frontend_release: frontend_build
	pushd frontend/build; \
		aws s3 cp --recursive --profile ${AWS_PROFILE} --region ${AWS_REGION} \
			./ s3://${AWS_PROFILE}-${ENV}-app/; \
		popd

# Backend package
backend_get:
	pushd backend; mix deps.get; popd

backend_update:
	pushd backend; mix deps.update --all; popd

backend_compile: backend_get
	pushd backend; mix compile; popd

backend_release: backend_compile
	pushd backend; MIX_ENV=${ENV} mix distillery.release --env=${ENV}; popd

# Local build
local_clean: local_down
	- sh ./scripts/clean.sh

local: local_down local_build local_up

test_db:
	docker run -d --name mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=root -e MYSQL_DATABASE=rabbit_recipe_test mysql:5.6.47

local_build:
	APP_NAME=${APP_NAME} \
		ENV=${ENV} \
		MASTER_USERNAME=root \
		MASTER_USERPASSWORD=root \
		MYSQL_HOSTNAME=mysql \
		docker-compose build

local_up:
	APP_NAME=${APP_NAME} ENV=${ENV} docker-compose up

local_down:
	docker-compose down
