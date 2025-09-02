#!/bin/bash

set -e

REGION="eu-west-1"
IMAGE_NAME="hello"
IMAGE_TAG="hello"
BUILD_CONTEXT="../Images/Hello"
CHART_PATH="../Charts/Hello"
TRAEFIK_CHART_PATH="../Charts/Traefik"
NAMESPACE="hello-ns"
RELEASE_NAME="hello"
TRAEFIK_RELEASE_NAME="traefik"

echo "Fetching ECR URI from Terraform..."
ECR_URI=$(terraform -chdir=../Infrastructure output -raw ecr_repository_url)

if [ -z "$ECR_URI" ]; then
  echo "Failed to retrieve ECR URI from Terraform output"
  exit 1
fi

FULL_TAG="${ECR_URI}:${IMAGE_TAG}"

aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ECR_URI

EXISTING_IMAGE=$(aws ecr describe-images \
  --repository-name $(basename $ECR_URI) \
  --region $REGION \
  --query "imageDetails[?contains(imageTags, '${IMAGE_TAG}')]" \
  --output text)

if [[ -n "$EXISTING_IMAGE" ]]; then
  echo "Image with tag '${IMAGE_TAG}' already exists in ECR. Skipping build and push."
else
  docker build -t $IMAGE_NAME $BUILD_CONTEXT
  docker tag $IMAGE_NAME:latest $FULL_TAG

  echo "Pushing image to ECR"
  docker push $FULL_TAG
  echo "Image pushed: $FULL_TAG"
fi

kubectl get namespace $NAMESPACE >/dev/null 2>&1 || kubectl create namespace $NAMESPACE

helm upgrade --install $TRAEFIK_RELEASE_NAME $TRAEFIK_CHART_PATH \
  --namespace $NAMESPACE --create-namespace

echo "Deploying Hello app"
helm upgrade --install $RELEASE_NAME $CHART_PATH \
  --namespace $NAMESPACE \
  --set image.repository=$ECR_URI \
  --set image.tag=$IMAGE_TAG

HELLO_URL=$(kubectl get svc hello-service -n $NAMESPACE -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")
TRAEFIK_URL=$(kubectl get svc traefik -n $NAMESPACE -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")

echo "Complete"