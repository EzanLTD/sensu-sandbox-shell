# Stopping firewall
/etc/init.d/iptables stop

# Install EPEL-6 yum repo
rpm -Uvh http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

# Install Erlang
yum -y install erlang

# Install RabbitMQ from RPM
rpm --import http://www.rabbitmq.com/rabbitmq-signing-key-public.asc
rpm -Uvh http://www.rabbitmq.com/releases/rabbitmq-server/v2.7.1/rabbitmq-server-2.7.1-1.noarch.rpm

# Install RabbitMQ management console
rabbitmq-plugins enable rabbitmq_management

# Start and verify RabbitMQ
chkconfig rabbitmq-server on
/etc/init.d/rabbitmq-server start

# Create RabbitMQ vhost and user for Sensu
rabbitmqctl add_vhost /sensu
rabbitmqctl add_user sensu sensu
rabbitmqctl set_permissions -p /sensu sensu ".*" ".*" ".*"

# Install Redis
yum -y install redis
chkconfig redis on
/etc/init.d/redis start

# Register Sensu-package repo
cat > /etc/yum.repos.d/sensu.repo << EOM
[sensu]
name=sensu-main
baseurl=http://repos.sensuapp.org/yum/el/6/x86_64/
gpgcheck=0
enabled=1
EOM

# Install Sensu "Omnibus" Package
yum -y install sensu

# Enable Sensu services
chkconfig sensu-server on
chkconfig sensu-api on
chkconfig sensu-client on
chkconfig sensu-dashboard on

# Start Sensu services
/etc/init.d/sensu-server start
/etc/init.d/sensu-api start
/etc/init.d/sensu-client start
/etc/init.d/sensu-dashboard start