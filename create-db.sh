# docker compose -f docker-compose/docker-compose-dev.yml up
export DATABASE_URL="postgresql://postgres:@localhost:7432/blockscout?ssl=false"
mix do ecto.drop, ecto.create, ecto.migrate
