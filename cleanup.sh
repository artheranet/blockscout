#!/bin/bash

mix do deps.get, local.rebar --force, deps.compile
mix phx.digest.clean

rm -rf _build/
mix do ecto.drop

cd apps/explorer && npm install; cd -

mkdir -p apps/explorer/priv/static
mkdir -p apps/ethereum_jsonrpc/priv/static
mkdir -p apps/indexer/priv/static
mkdir -p apps/block_scout_web/priv/static

mix phx.digest
cd apps/block_scout_web; mix phx.gen.cert blockscout blockscout.local; cd -

