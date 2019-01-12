set -ex

USERNAME=stormheg
IMAGE=nginx-php7-alpine

docker build -t $USERNAME/$IMAGE:latest .