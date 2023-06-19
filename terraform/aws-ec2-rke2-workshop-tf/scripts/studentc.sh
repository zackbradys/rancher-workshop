#!/bin/bash

set -ebpf

### Set Variables
export DOMAIN=${DOMAIN}
export NUM=${NUM}
export HOSTNAME=${HOSTNAME}

### Applying System Settings
cat << EOF >> /etc/sysctl.conf
# SWAP Settings
vm.swappiness=0
vm.panic_on_oom=0
vm.overcommit_memory=1
kernel.panic=10
kernel.panic_on_oops=1
vm.max_map_count = 262144

# IPv4 Connection Settings
net.ipv4.ip_local_port_range=1024 65000

# Increase Max Connection
net.core.somaxconn=10000

# Closed Socket Settings
net.ipv4.tcp_tw_reuse=1
net.ipv4.tcp_fin_timeout=15

# Increasing Backlogged Sockets (Default is 128)
net.core.somaxconn=4096
net.core.netdev_max_backlog=4096

# Increasing Socket Buffers
net.core.rmem_max=16777216
net.core.wmem_max=16777216

# Network Tuning Settings
net.ipv4.tcp_max_syn_backlog=20480
net.ipv4.tcp_max_tw_buckets=400000
net.ipv4.tcp_no_metrics_save=1
net.ipv4.tcp_rmem=4096 87380 16777216
net.ipv4.tcp_syn_retries=2
net.ipv4.tcp_synack_retries=2
net.ipv4.tcp_wmem=4096 65536 16777216

# ARP Cache Settings
net.ipv4.neigh.default.gc_thresh1=8096
net.ipv4.neigh.default.gc_thresh2=12288
net.ipv4.neigh.default.gc_thresh3=16384

# More IPv4 Settings
net.ipv4.tcp_keepalive_time=600
net.ipv4.ip_forward=1

# File System Monitoring
fs.inotify.max_user_instances=8192
fs.inotify.max_user_watches=1048576
EOF

sysctl -p > /dev/null 2>&1

### Updating SSH Settings
echo "root:Pa22word" | chpasswd
sed -i -e "s/PasswordAuthentication no/PasswordAuthentication yes/g" -e "s/#PermitRootLogin prohibit-password/PermitRootLogin yes/g" /etc/ssh/sshd_config
systemctl restart sshd

echo -e "StrictHostKeyChecking no" > /root/.ssh/config

### Install Packages
yum install -y zip zstd tree jq git container-selinux iptables libnetfilter_conntrack libnfnetlink libnftnl policycoreutils-python-utils cryptsetup
yum --setopt=tsflags=noscripts install -y nfs-utils
yum --setopt=tsflags=noscripts install -y iscsi-initiator-utils && echo "InitiatorName=$(/sbin/iscsi-iname)" > /etc/iscsi/initiatorname.iscsi && systemctl enable --now iscsid
echo -e "[keyfile]\nunmanaged-devices=interface-name:cali*;interface-name:flannel*" > /etc/NetworkManager/conf.d/rke2-canal.conf
yum update -y && yum clean all

### Setting Instance Environment
hostname $HOSTNAME
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