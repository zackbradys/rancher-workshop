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

### Install Helm
export HOME=/root
mkdir -p /opt/rancher/helm
cd /opt/rancher/helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh && ./get_helm.sh
mv /usr/local/bin/helm /usr/bin/helm

### Install Code Server
curl -fsSL https://code-server.dev/install.sh | sh
mkdir -p /root/.config/code-server/ /root/.local/share/code-server/User/
echo -e "bind-addr: 0.0.0.0:8080\nauth: password\npassword: Pa22word\ncert: false" > ~/.config/code-server/config.yaml
echo -e "{\n    \"terminal.integrated.defaultLocation\": \"editor\",\n    \"terminal.integrated.shell.linux\": \"/bin/bash\",\n    \"terminal.integrated.defaultProfile.linux\": \"bash\"\n}" > /root/.local/share/code-server/User/settings.json
systemctl enable --now code-server@root

cd /opt/
git clone https://github.com/zackbradys/rancher-workshop.git