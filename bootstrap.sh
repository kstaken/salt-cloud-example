#!/usr/bin/env bash

apt-get update
echo "127.0.0.1 salt salt-master" >> /etc/hosts

echo "salt-master" >> /etc/hostname
hostname salt-master

wget -O - http://bootstrap.saltstack.org | sudo sh
apt-get install -y salt-master python-pip
pip install --upgrade boto

source /vagrant/env.sh

sed -ie 's/#id:/id: salt-master/' /etc/salt/minion

service salt-minion restart

route53 change_record ${AWS_ROUTE53_DOMAIN} ${SALT_MASTER_HOSTNAME} A `curl --silent http://169.254.169.254/latest/meta-data/public-ipv4`  30

# We want to authorize the minion on the master
salt-key -a salt-master
# Then reject anything else. There will likely be a key from before we set id:
salt-key -Dy 

chown root ${AWS_SSH_PRIVKEY}
chmod 400 ${AWS_SSH_PRIVKEY}
cp /vagrant/salt/cloud /etc/salt/cloud
cp /vagrant/salt/cloud.profiles /etc/salt/cloud.profiles
