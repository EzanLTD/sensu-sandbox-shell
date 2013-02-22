apt-get -y install erlang-nox
echo "deb http://www.rabbitmq.com/debian/ testing main" >/etc/apt/sources.list.d/rabbitmq.list
curl -L -o ~/rabbitmq-signing-key-public.asc http://www.rabbitmq.com/rabbitmq-signing-key-public.asc
apt-key add ~/rabbitmq-signing-key-public.asc
apt-get update
apt-get -y --allow-unauthenticated --force-yes install rabbitmq-server

rabbitmq-plugins enable rabbitmq_management
update-rc.d rabbitmq-server defaults

rabbitmqctl add_vhost /sensu
rabbitmqctl add_user sensu mypass
rabbitmqctl set_permissions -p /sensu sensu ".*" ".*" ".*"

echo "deb http://backports.debian.org/debian-backports squeeze-backports main contrib non-free" >> /etc/apt/sources.list
apt-get update
apt-get -t squeeze-backports install redis-server

wget -q http://repos.sensuapp.org/apt/pubkey.gpg -O- | sudo apt-key add -
echo "deb http://repos.sensuapp.org/apt sensu main" >> /etc/apt/sources.list
apt-get update
apt-get install sensu

update-rc.d sensu-server defaults
update-rc.d sensu-api defaults
update-rc.d sensu-client defaults
update-rc.d sensu-dashboard defaults
