#!/bin/bash

REGION="eu-west-1"
IMAGE_NAME="hello_image"
DOCKERFILE_PATH="../Images/Hello"
CHART_PATH="../Charts/Hello"
NAMESPACE="hello-ns"
RELEASE_NAME="hello"

ECR_URI=$(terraform -chdir=../Infrastructure output -raw ecr_repository_url)

if [ -z "$ECR_URI" ]; then
  echo "Failed to get the output"
  exit 1
fi

aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ECR_URI

docker build -t $IMAGE_NAME $DOCKERFILE_PATH

docker tag $IMAGE_NAME:latest $ECR_URI:hello

docker push $ECR_URI:hello

helm upgrade --install $RELEASE_NAME $CHART_PATH \
  --namespace $NAMESPACE \
  --create-namespace