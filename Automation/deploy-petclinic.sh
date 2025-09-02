#!/bin/bash

set -e

REGION="eu-west-1"
IMAGE_NAME="petclinic"
IMAGE_TAG="petclinic"
BUILD_CONTEXT="../Images/Petclinic"
CHART_PATH="../Charts/Petclinic"
NAMESPACE="petclinic-ns"
RELEASE_NAME="petclinic"

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
  echo "Building Docker image"
  docker build -t $IMAGE_NAME $BUILD_CONTEXT
  docker tag $IMAGE_NAME:latest $FULL_TAG

  echo "Pushing image to ECR"
  docker push $FULL_TAG
fi

kubectl get namespace $NAMESPACE >/dev/null 2>&1 || kubectl create namespace $NAMESPACE

echo "Deploying Petclinic"
helm upgrade --install $RELEASE_NAME $CHART_PATH \
  --namespace $NAMESPACE \
  --set image.repository=$ECR_URI \
  --set image.tag=$IMAGE_TAG

echo "Petclinic deployed"
