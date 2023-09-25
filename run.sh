#!/bin/bash

set -o allexport
source ./docker-compose/envs/arthera-blockscout.env
set +o allexport

mix deps.compile explorer
mix deps.compile indexer
mix deps.compile block_scout_web
mix deps.compile ethereum_jsonrpc

export DATABASE_URL="postgresql://postgres:@localhost:7432/blockscout?ssl=false"
export ACCOUNT_REDIS_URL=redis://localhost:7379

mix phx.server
