include .env

# DOCKER
docker-build:
	docker compose build --no-cache

docker-start:
	docker compose --env-file .env up

# COGNITO
create-cognito-user-pool:
	docker-compose exec localstack awslocal cognito-idp create-user-pool \
		--pool-name ConsumersPool \
		--region $(AWS_REGION) | tee /tmp/cognito_pool_output.json

	$(eval AWS_COGNITO_CONSUMERS_POOL_ID := $(shell jq -r '.UserPool.Id' /tmp/cognito_pool_output.json))

	docker-compose exec localstack awslocal cognito-idp create-user-pool-client \
		--user-pool-id $(AWS_COGNITO_CONSUMERS_POOL_ID) \
		--client-name ConsumersClient \
		--region $(AWS_REGION) | tee /tmp/cognito_client_output.json

	$(eval AWS_COGNITO_CONSUMERS_CLIENT_ID := $(shell jq -r '.UserPoolClient.ClientId' /tmp/cognito_client_output.json))

create-cognito-lessors-pool:
	docker-compose exec localstack awslocal cognito-idp create-user-pool \
		--pool-name LessorsPool \
		--region $(AWS_REGION) | tee /tmp/cognito_lessors_pool_output.json

	$(eval AWS_COGNITO_LESSORS_POOL_ID := $(shell jq -r '.UserPool.Id' /tmp/cognito_lessors_pool_output.json))

	docker-compose exec localstack awslocal cognito-idp create-user-pool-client \
		--user-pool-id $(AWS_COGNITO_LESSORS_POOL_ID) \
		--client-name LessorsClient \
		--region $(AWS_REGION) | tee /tmp/cognito_lessors_client_output.json

	$(eval AWS_COGNITO_LESSORS_CLIENT_ID := $(shell jq -r '.UserPoolClient.ClientId' /tmp/cognito_lessors_client_output.json))

setup-cognito:
	$(MAKE) create-cognito-user-pool
	$(MAKE) create-cognito-lessors-pool
