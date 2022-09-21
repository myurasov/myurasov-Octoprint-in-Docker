#!/bin/bash

UP1_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")"/.. >/dev/null && pwd)"
THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null && pwd)"
IMAGE_NAME=`cd "${UP1_DIR}" && echo ${PWD##*/} | tr '[:upper:]' '[:lower:]' | sed -e 's/[-_ ]+/-/g'`
OCTOPRINT_PORT=80
DOCKER_RUN_FLAGS="it"
FOREVER=0
BUILD=1
KILL=1
CMD=""

# process named arguments
while [ $# -gt 0 ]; do
  case "$1" in
    --port=*)
      OCTOPRINT_PORT="${1#*=}"
      ;;
    --image_suffix=*)
      IMAGE_NAME="${IMAGE_NAME}-${1#*=}"
      ;;
    --gpus=*)
      GPUS="${1#*=}"
      ;;
    --forever)
      DOCKER_RUN_FLAGS+="d"
      ;;
    --no-kill)
      KILL=0
      ;;
    --no-build)
      BUILD=0
      ;;
    --help)
      echo "Usage: docker.sh [--port=####|80] [--help] [command]"
      exit
      ;;
    *)
      CMD="${1}"
  esac
  shift
done

if [ $KILL -ge 1 ]
  then
    echo "Killing ${IMAGE_NAME}..."
    docker kill "${IMAGE_NAME}"
fi

if [ $BUILD -ge 1 ]
  then
    echo "Building ${IMAGE_NAME}..."
    docker build -f "${THIS_DIR}/Dockerfile" -t $IMAGE_NAME "${UP1_DIR}" || exit 1
fi

# only map jupyter/tensorboard ports if command is not specified
if [ -z "$CMD" ]
  then
    PORT_MAPPINGS_ARG="-p ${OCTOPRINT_PORT}:80"
fi

docker run --privileged --restart unless-stopped "-${DOCKER_RUN_FLAGS}" \
  --name="${IMAGE_NAME}" \
  -v "${UP1_DIR}:/app" \
  $PORT_MAPPINGS_ARG \
  $IMAGE_NAME \
  $CMD
