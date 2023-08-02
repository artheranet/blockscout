apt update
apt install-y postgresql-14 mc libssl-dev make automake autoconf libncurses5-dev g++ ca-certificates curl gnupg redis-server openssl git libtool-bin libgmp-dev nginx

nano /etc/postgresql/14/main/pg_hba.conf
+ host    all             all             192.168.0.0/16            scram-sha-256
+ host    all             all             172.0.0.0/8            scram-sha-256

nano /etc/postgresql/14/main/postgresql.conf
+ listen_addresses = '*'
+ port = 5432
+ max_connections = 1000

systemctl enable postgresql
systemctl restart postgresql

su - postgres
psql
\password
asdqwe123

nano /etc/redis/redis.conf
+ supervised systemd
  systemctl enable redis-server
  systemctl restart redis-server


install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg
echo \
"deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
"$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

curl -O https://raw.githubusercontent.com/kerl/kerl/master/kerl
chmod 755 kerl
./kerl build 24.3.4.10
./kerl install 24.3.4.10 /opt/erlang-24.3.4.10

\curl -sSL https://raw.githubusercontent.com/taylor/kiex/master/install | bash -s

echo "source /opt/erlang-24.3.4.10/activate" >> ~/.bashrc
echo "source $HOME/.kiex/scripts/kiex" >> ~/.bashrc
source ~/.bashrc

kiex install 1.13.4
echo "source $HOME/.kiex/elixirs/elixir-1.13.4.env" >> ~/.bashrc
source ~/.bashrc

curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash
apt-get install -y nodejs

nano /etc/systemd/system/explorer.service
+
[Unit]
Description=Blockscout Server
After=network.target
StartLimitIntervalSec=0

[Service]
Type=simple
Restart=always
RestartSec=1
User=root
StandardOutput=syslog
StandardError=syslog
WorkingDirectory=/opt/blockscout
ExecStart=/opt/start-explorer.sh
EnvironmentFile=/opt/blockscout.env

[Install]
WantedBy=multi-user.target
+

systemctl daemon-reload

nano /opt/start-explorer.sh
+
#!/bin/bash

source /opt/erlang-24.3.4.10/activate
source /root/.kiex/scripts/kiex
source /root/.kiex/elixirs/elixir-1.13.4.env
mix phx.server
+

chmod 755 /opt/start-explorer.sh

nano /opt/blockscout.env
+...+

export $(grep -v '^#' /opt/blockscout.env | xargs -d '\n')

cd /opt
git clone https://github.com/artheranet/blockscout.git
cd blockscout
mix local.hex --force
mix do deps.get, local.rebar --force, deps.compile
export DATABASE_URL="postgresql://postgres:asdqwe123@localhost:5432/blockscout"
mix do ecto.drop, ecto.create, ecto.migrate

systemctl start explorer


docker compose up -d
