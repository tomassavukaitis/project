#!/bin/bash

REGION="eu-west-1"
IMAGE_NAME="hello_image"
HELLODOCKERFILE_PATH="../Images/Hello"
HELLOCHART_PATH="../Charts/Hello"
TRAEFIKDOCKERFILE_PATH="../Images/Traefik"
TRAEFIKCHART_PATH="../Charts/Traefik"
NAMESPACE="hello-ns"
HELLORELEASE_NAME="hello"
TRAEFIKREALEASE_NAME="traefik"

ECR_URI=$(terraform -chdir=../Infrastructure output -raw ecr_repository_url)

if [ -z "$ECR_URI" ]; then
  echo "Failed to get the output"
  exit 1
fi

aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ECR_URI

docker build -t $IMAGE_NAME $HELLODOCKERFILE_PATH

docker tag $IMAGE_NAME:latest $ECR_URI:hello

docker push $ECR_URI:hello

echo "deploying traefik"
helm upgrade --install $TRAEFIKREALEASE_NAME $TRAEFIKCHART_PATH --namespace $NAMESPACE --create-namespace

echo "deploying hello"
helm upgrade --install $HELLORELEASE_NAME $HELLOCHART_PATH \
  --namespace $NAMESPACE 

HELLO_URL=$(kubectl get svc hello-service -n $NAMESPACE -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")
TRAEFIK_URL=$(kubectl get svc traefik -n $NAMESPACE -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")

echo "Complete"
echo "HelloURL: http://$HELLO_URL"
echo "Traefik URL: http://$TRAEFIK_URL"
