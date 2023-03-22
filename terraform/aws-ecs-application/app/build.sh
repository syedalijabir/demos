#! /bin/bash

IMAGE="syedalijabir/simple-app"

docker build --platform linux/amd64 -t ${IMAGE}:latest .
docker push ${IMAGE}:latest
docker tag ${IMAGE}:latest ${IMAGE}:amd64
docker push ${IMAGE}:amd64

docker build --platform linux/arm64 -t ${IMAGE}:arm64 .
docker push ${IMAGE}:arm64

echo Done.
