#!/bin/bash

# DTR_ADDRESS - ENV should be set for pushing to DTR, format is DNS or IP:port

# Input Parameters
# IMAGE_TAG - optional tag, default 'latest'

IMAGE_TAG=$1
if [[ -z "${IMAGE_TAG}" ]]; then
  IMAGE_TAG="latest"
fi

### CHANGE THIS
IMAGE_NAMESPACE="rupakg"
IMAGE_NAME="preso-slides"

# push the image to DTR
if [[ "${DTR_ADDRESS}" == "" ]]; then
  # tag the build
  docker push ${IMAGE_NAMESPACE}/${IMAGE_NAME}:${IMAGE_TAG}
  if [[ "${IMAGE_TAG}" != "latest" ]]; then
    # push the image with 'latest' tag as well
    docker tag ${IMAGE_NAMESPACE}/${IMAGE_NAME}:${IMAGE_TAG} ${IMAGE_NAMESPACE}/${IMAGE_NAME}:latest
    docker push ${IMAGE_NAMESPACE}/${IMAGE_NAME}:latest
  fi
  if [[ "$?" != "0" ]]; then
    echo -e "\n Problem with docker push.... Aborting"
    exit -1;
  fi
else
  # tag the build
  docker tag ${IMAGE_NAMESPACE}/${IMAGE_NAME}:${IMAGE_TAG} ${DTR_ADDRESS}/${IMAGE_NAMESPACE}/${IMAGE_NAME}:${IMAGE_TAG}
  docker push ${DTR_ADDRESS}/${IMAGE_NAMESPACE}/${IMAGE_NAME}:${IMAGE_TAG}
  if [[ "${IMAGE_TAG}" != "latest" ]]; then
    # push the image with 'latest' tag as well
    docker tag ${IMAGE_NAMESPACE}/${IMAGE_NAME}:${IMAGE_TAG} ${DTR_ADDRESS}/${IMAGE_NAMESPACE}/${IMAGE_NAME}:latest
    docker push ${DTR_ADDRESS}/${IMAGE_NAMESPACE}/${IMAGE_NAME}:latest
  fi
  if [[ "$?" != "0" ]]; then
    echo -e "\n Problem with docker push.... Aborting"
    exit -1;
  fi
fi

echo -e "\n Docker push successful."
