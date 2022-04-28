CHIP_DB_USERNAME=chipdbuser
CHIP_DB_PASSWORD=chipdbpw
CHIP_DB_NAME=chipdb
CHIP_DB_HOST=localhost

# Perform update of all of the installed packages.
yum update -y

# Install wget so that we can download packages
yum install wget -y

# Add the EPEL repo to yum
yum install epel-release -y

# Add the Erlang Solutions repo to yum
wget http://packages.erlang-solutions.com/erlang-solutions-1.0-1.noarch.rpm
rpm -Uvh erlang-solutions-1.0-1.noarch.rpm

# Install ESL Erlang
yum install esl-erlang -y

# Install NGINX
yum install nginx -y

# Enable NGINX to start on boot
systemctl enable nginx

# Install Git
yum install git -y

# Clone the Elixir repo and build Elixir from source
git clone https://github.com/elixir-lang/elixir.git
cd elixir/
git checkout v1.6
make clean test
find . -print | cpio -pmud /opt/elixir

# Add elixir commands to path
echo "export PATH=\$PATH:/opt/elixir/bin" >> /etc/profile.d/chip.sh
export PATH=$PATH:/opt/elixir/bin

# Need to cd back to home directory here.
cd

# Install PostgreSQL database
wget https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-7-x86_64/pgdg-centos10-10-2.noarch.rpm
yum install pgdg-centos10-10-2.noarch.rpm -y

yum install postgresql10-server postgresql10-contrib -y


# Initialize PostgreSQL database
/usr/pgsql-10/bin/postgresql-10-setup initdb

# Allow our CHIP user to authenticate to database
# This line will break if the default postgresql file has been changed.
sed -i "82ihost    all             ${CHIP_DB_USERNAME}      127.0.0.1/32            trust" /var/lib/pgsql/10/data/pg_hba.conf

# Start PostgreSQL
systemctl enable postgresql-10
systemctl start postgresql-10
sudo su - postgres -c "psql -c \"CREATE USER ${CHIP_DB_USERNAME} PASSWORD '${CHIP_DB_PASSWORD}'\""
sudo su - postgres -c "psql -c \"ALTER USER ${CHIP_DB_USERNAME} CREATEDB\""

# Install Node.js
#wget https://nodejs.org/dist/latest-v8.x/node-v8.12.0-linux-x64.tar.gz
wget https://nodejs.org/dist/latest-v16.x/node-v16.14.2-linux-x64.tar.gz
gunzip node-v16.14.2-linux-x64.tar.gz 
cd /opt
mkdir node
cd node
tar xf ~/node-v16.14.2-linux-x64.tar

# Update PATH to include Node
echo "export PATH=\$PATH:/opt/node/node-v16.14.2-linux-x64/bin" >> /etc/profile.d/chip.sh
export PATH=$PATH:/opt/node/node-v16.14.2-linux-x64/bin

# Add user 'chipdev' to build app components
useradd chipdev

# Go back to our HOME directory
cd

cd /tmp
# shawnmgoulet
git clone https://shawnmgoulet@bitbucket.org/timmonsgroup/ccc.git
chown -R chipdev:chipdev /tmp/ccc

# Install yarn globally
npm install -g yarn

cat > ~chipdev/build.sh << HERE2
mkdir Projects
cd Projects

cd /tmp/ccc
find . -print | cpio -pmud ~/Projects/ccc

cd ~/Projects/ccc

cd chip_api

cat >config/prod.secret.exs <<- HERE1 
use Mix.Config

config :chip_api, ChipApi.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "${CHIP_DB_USERNAME}",
  password: "${CHIP_DB_PASSWORD}",
  database: "${CHIP_DB_NAME}",
  hostname: "${CHIP_DB_HOST}"
HERE1


export MIX_ENV=prod
export PORT=8081
mix local.hex --force
mix local.rebar --force
mix deps.get
mix release --env=prod
mix ecto.reset --env=prod

cd ~/Projects/ccc/chip_app

yarn set version berry

rm -f package-lock.json
rm -f yarn.lock

yarn install
yarn run build
HERE2

chown chipdev:chipdev ~chipdev/build.sh
chmod +x ~chipdev/build.sh

# Execute remainder of script as 'chipdev' user
su - chipdev -c "~/build.sh"

# create user and group for app services
groupadd chip
useradd chip -g chip

# make directory to store apps
cd /opt
mkdir chip
cd chip
mkdir chip_api

# unzip api app into its new home
cd chip_api
tar xvzf ~chipdev/Projects/ccc/chip_api/_build/prod/rel/chip_api/releases/0.0.1/chip_api.tar.gz

chown -R chip:chip /opt/chip


# lets create a 'systemd' service parameter file for our new app(api)
cat > /usr/lib/systemd/system/chip-api.service << HERE3
[Unit]
Description=ChipApi
After=network.target

[Service]
Type=simple
User=chip
Group=chip
WorkingDirectory=/opt/chip/chip_api
ExecStart=/opt/chip/chip_api/bin/chip_api foreground
Restart=on-failure
RestartSec=5
Environment=PORT=8081
Environment=REPLACE_OS_VARS=true
Environment=COOKIE=ASB123CEF4567
Environment=LANG=en_US.UTF-8
SyslogIdentifier=chip-api
RemainAfterExit=no

[Install]
WantedBy=multi-user.target
HERE3

# Set up SELinux to allow proxy connections
setsebool httpd_can_network_connect on -P

cd /usr/share/nginx/html
rm -f index.html
cp -R ~chipdev/Projects/ccc/chip_app/build/* .

#configure NGINX proxy settings.
# TODO:
cat > /etc/nginx/conf.d/chip.conf << HERE4
    log_format upstreamlog '[\$time_local] \$remote_addr - \$remote_user - \$server_name to: \$upstream_addr: \$request upstream_response_time \$upstream_response_time msec \$msec request_time \$request_time';
HERE4

cat > /etc/nginx/default.d/chip.conf << HERE5
        location /api {

             access_log  /var/log/nginx/api_proxy.log upstreamlog;
             proxy_set_header X-RealIP \$remote_addr;
             proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
             proxy_http_version 1.1;
             proxy_set_header Connection "";
             proxy_pass http://[::1]:8081;
        }

        location /images {

             access_log  /var/log/nginx/api_proxy.log upstreamlog;
             proxy_set_header X-Real-IP \$remote_addr;
             proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
             proxy_http_version 1.1;
             proxy_set_header Connection "";
             proxy_pass http://[::1]:8081/images;
        }

        location /graphiql {

             access_log  /var/log/nginx/graphiql_proxy.log upstreamlog;
             proxy_set_header   X-Real-IP \$remote_addr;
             proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
             proxy_http_version 1.1;
             proxy_set_header Connection "";
             proxy_pass http://[::1]:8081/graphiql;
        }
HERE5

systemctl start chip-api
systemctl start nginx

