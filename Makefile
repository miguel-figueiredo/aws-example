.PHONY: help dev jar docker docker-run docker-login docker-push

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

dev: # Runs the dev environment
	mvn spring-boot:run

jar: ## Builds jar
	mvn clean package

docker: jar ## Builds docker image
	cp target/aws-example-0.0.1-SNAPSHOT.jar src/main/docker
	docker build -f src/main/docker/Dockerfile src/main/docker -t public.ecr.aws/s0w1a8x5/team-maldita:latest

docker-run: docker ## Runs the docker image
	docker run -p 8080:8080 public.ecr.aws/s0w1a8x5/team-maldita:latest

docker-login: ## Logins using AWS CLI
	aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/s0w1a8x5

docker-push: docker ## Pushes docker image
	docker push public.ecr.aws/s0w1a8x5/team-maldita:latest