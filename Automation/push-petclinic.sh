#!/bin/bash

IMAGE_NAME="petclinic"
IMAGE_TAG="petclinic"
ECR_REPO="590183826893.dkr.ecr.eu-west-1.amazonaws.com/image_repo"
FULL_TAG="${ECR_REPO}:${IMAGE_TAG}"
BUILD_CONTEXT="../Images/Petclinic"

EXISTING_IMAGE=$(aws ecr describe-images \
  --repository-name image_repo \
  --region eu-west-1 \
  --query "imageDetails[?contains(imageTags, '${IMAGE_TAG}')]" \
  --output text)

if [[ -n "$EXISTING_IMAGE" ]]; then
  echo "Image with tag '${IMAGE_TAG}' exists in ECR. Stopping."
  exit 0
fi

docker build -t ${FULL_TAG} ${BUILD_CONTEXT}

aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin ${ECR_REPO}

echo "Pushing image to ECR"
docker push ${FULL_TAG} 

echo "Image pushed to: ${FULL_TAG}"
