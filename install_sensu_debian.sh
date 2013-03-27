# Install Erlang
apt-get -y install erlang-nox

# Install RabbitMQ
echo "deb http://www.rabbitmq.com/debian/ testing main" >/etc/apt/sources.list.d/rabbitmq.list

curl -L -o ~/rabbitmq-signing-key-public.asc http://www.rabbitmq.com/rabbitmq-signing-key-public.asc
apt-key add ~/rabbitmq-signing-key-public.asc

apt-get update
apt-get -y --allow-unauthenticated --force-yes install rabbitmq-server

# Install RabbitMQ management console
rabbitmq-plugins enable rabbitmq_management

# Start and verify RabbitMQ
update-rc.d rabbitmq-server defaults
/etc/init.d/rabbitmq-server start

# Create RabbitMQ vhost and user for Sensu
rabbitmqctl add_vhost /sensu
rabbitmqctl add_user sensu sensu
rabbitmqctl set_permissions -p /sensu sensu ".*" ".*" ".*"

# Install Redis
echo "deb http://backports.debian.org/debian-backports squeeze-backports main contrib non-free" >> /etc/apt/sources.list
apt-get update
apt-get -t squeeze-backports install redis-server

# Register Sensu-package repo
wget -q http://repos.sensuapp.org/apt/pubkey.gpg -O- | sudo apt-key add -
echo "deb http://repos.sensuapp.org/apt sensu main" >> /etc/apt/sources.list

# Install Sensu "Omnibus" Package
apt-get update
apt-get install sensu

# Enable Sensu services
update-rc.d sensu-server defaults
update-rc.d sensu-api defaults
update-rc.d sensu-client defaults
update-rc.d sensu-dashboard defaults

# Start Sensu services
/etc/init.d/sensu-server start
/etc/init.d/sensu-api start
/etc/init.d/sensu-client start
/etc/init.d/sensu-dashboard start
