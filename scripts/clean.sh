# /bin/bash
set -x

# Clean up docker process, images

CURRENT_DIR=`pwd`
APP_NAME=`basename ${CURRENT_DIR}`

# Process
docker rm --force `docker ps -a -q -f name=${APP_NAME}*`

# Images
docker rmi --force `docker images -a -q ${APP_NAME}*`

# Dangling images
docker rmi --force `docker images -q -f dangling=true`
