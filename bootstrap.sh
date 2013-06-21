#!/usr/bin/env bash

apt-get update
echo "127.0.0.1 salt salt-master" >> /etc/hosts

echo "salt-master" >> /etc/hostname
hostname salt-master

wget -O - http://bootstrap.saltstack.org | sudo sh
apt-get install -y salt-master python-pip curl
pip install --upgrade boto

source /vagrant/env.sh

# We want to pre-authorize the minion on the master
salt-key --gen-keys=salt-master
cp salt-master.pub /etc/salt/pki/minion/minion.pub
cp salt-master.pem /etc/salt/pki/minion/minion.pem
cp salt-master.pub /etc/salt/pki/master/minions/salt-master

sed -ie 's/#id:/id: salt-master/' /etc/salt/minion

service salt-minion restart

route53 change_record ${AWS_ROUTE53_DOMAIN} ${SALT_MASTER_HOSTNAME} A `curl --silent http://169.254.169.254/latest/meta-data/public-ipv4`  30

TIMEOUT=90
COUNT=0
while [ ! -f /etc/salt/pki/minion/minion_master.pub ]; do
    echo "Waiting for salt install."
    if [ "$COUNT" -ge "$TIMEOUT" ]; then
        echo "minion_master.pub not detected by timeout"
        exit 1
    fi
    sleep 5
    COUNT=$((COUNT+5))
done

# Salt should be up and running so everything else can come from highstate
salt-call state.highstate