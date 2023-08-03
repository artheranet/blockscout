#!/bin/bash

export RELEASE_VERSION=5.2.1
export BS_CONTAINER_IMAGE=arthera/blockscout

docker build -f ./Dockerfile -t "$BS_CONTAINER_IMAGE:$RELEASE_VERSION" \
  --build-arg RELEASE_VERSION=$RELEASE_VERSION \
  --build-arg CACHE_EXCHANGE_RATES_PERIOD="" \
  --build-arg API_V1_READ_METHODS_DISABLED=false \
  --build-arg DISABLE_WEBAPP=true \
  --build-arg API_V1_WRITE_METHODS_DISABLED=false \
  --build-arg CACHE_TOTAL_GAS_USAGE_COUNTER_ENABLED="" \
  --build-arg CACHE_ADDRESS_WITH_BALANCES_UPDATE_INTERVAL="" \
  --build-arg ADMIN_PANEL_ENABLED="" \
  ../

docker tag "$BS_CONTAINER_IMAGE:$RELEASE_VERSION" "$BS_CONTAINER_IMAGE:latest"
docker login
docker push "$BS_CONTAINER_IMAGE:$RELEASE_VERSION"
docker push "$BS_CONTAINER_IMAGE:latest"
docker logout
