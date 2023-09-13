#!/bin/bash

set -ebpf

### Set Variables
export DOMAIN=${DOMAIN}
export NUM=${NUM}
export HOSTNAME=${HOSTNAME}

### Updating SSH Settings
echo "root:Pa22word" | chpasswd
sed -i -e "s/PasswordAuthentication no/PasswordAuthentication yes/g" -e "s/#PermitRootLogin prohibit-password/PermitRootLogin yes/g" /etc/ssh/sshd_config
systemctl restart sshd

echo -e "StrictHostKeyChecking no" > /root/.ssh/config

### Install Packages
yum install -y zip zstd tree jq git container-selinux iptables libnetfilter_conntrack libnfnetlink libnftnl policycoreutils-python-utils cryptsetup
yum install -y nfs-utils && yum install -y iscsi-initiator-utils && echo "InitiatorName=$(/sbin/iscsi-iname)" > /etc/iscsi/initiatorname.iscsi && systemctl enable --now iscsid
echo -e "[keyfile]\nunmanaged-devices=interface-name:cali*;interface-name:flannel*" > /etc/NetworkManager/conf.d/rke2-canal.conf

### Setting Instance Environment
hostnamectl set-hostname $HOSTNAME
echo -e "export HOME=/root" >> ~/.bashrc
echo -e "export PATH=\$PATH:/opt/bin" >> ~/.bashrc

### Setting Bash Environment
echo -e "export DOMAIN=$DOMAIN" >> ~/.bashrc
echo -e "export NUM=$NUM" >> ~/.bashrc
echo -e "export HOSTNAME=$HOSTNAME" >> ~/.bashrc
echo -e "export studenta=student${NUM}a.${DOMAIN}" >> ~/.bashrc
echo -e "export studentb=student${NUM}b.${DOMAIN}" >> ~/.bashrc
echo -e "export studentc=student${NUM}c.${DOMAIN}" >> ~/.bashrc
source ~/.bashrc