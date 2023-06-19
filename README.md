# Rancher Government Solutions Workshop

![rancher-long-banner](./images/rgs-banner-rounded.png)

### Table of Contents
* [About Me](#about-me)
* [Introduction](#introduction)
* [Infrastructure](#infrastructure)
* [Rancher RKE2](#rancher-rke2)
* [Rancher Multi Cluster Manager](#rancher-multi-cluster-manager)
* [Rancher Longhorn](#rancher-longhorn)
* [Rancher NeuVector](#rancher-neuvector)
* [Gitea and Fleet](#gitea-and-fleet)
* [Questions/Comments](#questions/comments)

## About Me
A little bit about me, my history, and what I've done in the industry. 
- DOD/IC Contractor
- U.S. Military Veteran
- Open-Source Contributor
- Built and Exited a Digital Firm
- Active Volunteer Firefighter/EMT

## Introduction

### Welcome to the Rancher Government Solutions Workshop! 
We will be installing, configuring, and deploying the entire Rancher Stack, including: Rancher RKE2, Rancher Multi-Cluster Manager, Rancher Longhorn, and Rancher NeuVector. Additionally, we will be enabling all hardened features such as CIS Profiles, DISA STIGS, and more. For ease of the workshop, we will not be simulating an airgap. If you would like to find out more about how easy the Rancher Stack can be airgapped, please reach out!

You are welcome to follow along with me or skip ahead, all the instructions are included below and it's all copy/paste. Don't worry... we have had plenty of folks forget how to copy/paste... you will not be the first, so please ask questions!

Before we get started, I wanted to shout out to **[@clemenko](https://github.com/clemenko)** for the basis of this workshop. 

### The Rancher Stack:
* Rancher RKE2 (Kubernetes Engine) - [learn more](https://www.rancher.com/products/rke)
* Rancher MCM (Cluster Management) - [learn more](https://www.rancher.com/products/rancher)
* Longhorn (Storage) - [learn more](https://www.rancher.com/products/longhorn)
* Neuvector (Security) - [learn more](https://ranchergovernment.com/neuvector)
* An awesome demo application or two :)

## Infrastructure

### Prerequistes

* Basic Linux command line skills
* Familiarity with a text editor (VSCode aka Code-Server)
* Every student has 3 vms.
  * The instructor will assign the student a number.
  * Rocky Linux 9
* ASK QUESTIONS!

### Student Environment Signup

http://workshop-signup.rancherfederal.io

### Access the Environment

Access URL: `http://student$NUMa.rancherfederal.training:8080`

Password = `Pa22word`

### DISA STIGS?!!

You can download the STIGs for Rancher RKE2 and the Rancher Multi Cluster Manager below. For this workshop, we will be using all the latest controls.
* [RGS_RKE2_V1R2_STIG](https://dl.dod.cyber.mil/wp-content/uploads/stigs/zip/U_RGS_RKE2_V1R2_STIG.zip)
* [RGS_MCM_V1R2_STIG](https://dl.dod.cyber.mil/wp-content/uploads/stigs/zip/U_RGS_MCM_V1R2_STIG.zip)
* [DISA STIG Viewer](https://public.cyber.mil/stigs/srg-stig-tools/).

If you're curious to learn more about them, there is a nice article about it from [Businesswire](https://www.businesswire.com/news/home/20221101005546/en/DISA-Validates-Rancher-Government-Solutions%E2%80%99-Kubernetes-Distribution-RKE2-Security-Technical-Implementation-Guide).
We even have a tldr for Rancher [here](https://github.com/clemenko/rancher_stig)!

## Rancher RKE2

If you are bored you can read the [docs](https://docs.rke2.io/). For speed, we are completing an online installation.

There is another git repository with all the air-gapping instructions [https://github.com/clemenko/rke_airgap_install](https://github.com/clemenko/rke_airgap_install).

Heck [watch the video](https://www.youtube.com/watch?v=IkQJc5-_duo).

### studenta

SSH in and run the following commands. Take your time. Some commands can take a few minutes.

```bash
### Setup RKE2 Server
mkdir -p /opt/rke2-artifacts
cd /opt/rke2-artifacts
useradd -r -c "etcd user" -s /sbin/nologin -M etcd -U
mkdir -p /etc/rancher/rke2/ /var/lib/rancher/rke2/server/manifests/

### Configure RKE2 Config
cat << EOF >> /etc/rancher/rke2/config.yaml
#profile: cis-1.6
selinux: true
secrets-encryption: true
write-kubeconfig-mode: 0600
kube-controller-manager-arg:
- bind-address=127.0.0.1
- use-service-account-credentials=true
- tls-min-version=VersionTLS12
- tls-cipher-suites=TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384
kube-scheduler-arg:
- tls-min-version=VersionTLS12
- tls-cipher-suites=TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384
kube-apiserver-arg:
- tls-min-version=VersionTLS12
- tls-cipher-suites=TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384
- authorization-mode=RBAC,Node
- anonymous-auth=false
- audit-policy-file=/etc/rancher/rke2/audit-policy.yaml
- audit-log-mode=blocking-strict
- audit-log-maxage=30
kubelet-arg:
- protect-kernel-defaults=true
- read-only-port=0
- authorization-mode=Webhook
- streaming-connection-idle-timeout=5m
- max-pods=200
cloud-provider-name: aws
token=RGSsuperduperfunWorkshop
EOF

### Configure RKE2 Audit Policy
cat << EOF >> /etc/rancher/rke2/audit-policy.yaml
apiVersion: audit.k8s.io/v1
kind: Policy
rules:
- level: RequestResponse
EOF

### Congiure NGINX Policies
cat << EOF >> /var/lib/rancher/rke2/server/manifests/rke2-ingress-nginx-config.yaml
---
apiVersion: helm.cattle.io/v1
kind: HelmChartConfig
metadata:
  name: rke2-ingress-nginx
  namespace: kube-system
spec:
  valuesContent: |-
    controller:
      config:
        use-forwarded-headers: true
      extraArgs:
        enable-ssl-passthrough: true
EOF
```

```bash
### Download and Install RKE2 Server
### Install Options --> https://docs.rke2.io/install/install_options/server_config/
curl -sfL https://get.rke2.io | INSTALL_RKE2_CHANNEL=v1.24 INSTALL_RKE2_TYPE=server sh - 

### Enable and Start the RKE2 Server
systemctl enable --now rke2-server.service
```

```bash
### Wait and Add Links
export KUBECONFIG=/etc/rancher/rke2/rke2.yaml
sudo ln -s /var/lib/rancher/rke2/data/v1*/bin/kubectl /usr/bin/kubectl
sudo ln -s /var/run/k3s/containerd/containerd.sock /var/run/containerd/containerd.sock

### Verify RKE2 Kubectl
kubectl get nodes -o wide
```

### studentb and studentc

Let's run the same commands on the other two servers, studentb and studentc.

```bash
### Setup RKE2 Agent
mkdir -p /etc/rancher/rke2/

### Configure RKE2 Config
cat << EOF >> /etc/rancher/rke2/config.yaml
#profile: cis-1.6
write-kubeconfig-mode: 0640
kube-apiserver-arg:
- authorization-mode=RBAC,Node
kubelet-arg:
- protect-kernel-defaults=true
- streaming-connection-idle-timeout=5m
- max-pods=200
cloud-provider-name: aws
server: https://$ipa:9345
token: RGSsuperduperfunWorkshop
EOF
```

```bash
### Download and Install RKE2 Agent
### Install Options --> https://docs.rke2.io/install/install_options/linux_agent_config/
curl -sfL https://get.rke2.io | INSTALL_RKE2_CHANNEL=v1.24 INSTALL_RKE2_TYPE=agent sh -

### Enable and Start the RKE2 Agent
systemctl enable --now rke2-agent.service
```

## Rancher Multi Cluster Manager

For time, let's install Rancher in an online fashion.

Note we are installing online for speed. Please see the [Air Gap Install](https://longhorn.io/docs/1.3.2/advanced-resources/deploy/airgap/#using-a-helm-chart) guide.

```bash
# add repos
helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
helm repo add jetstack https://charts.jetstack.io
helm repo update

# install cert-mamanger
helm upgrade -i cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace --set installCRDs=true

# now for rancher
helm upgrade -i rancher rancher-latest/rancher --namespace cattle-system --create-namespace --set hostname=rancher.$NUM.rancherfederal.training --set bootstrapPassword=Pa22word --set replicas=1 --set auditLog.level=2 --set auditLog.destination=hostPath

# go to page
echo "---------------------------------------------------------"
echo " control/command click : http://rancher.$NUM.rancherfederal.training"
echo "---------------------------------------------------------"

```

The username is `admin`.
The password is `Pa22word`.

## Rancher Longhorn

Here is the easiest way to build stateful storage on this cluster. [Longhorn](https://longhorn.io) from Rancher is awesome. Lets deploy from the first node.

Note we are installing online for speed. Please see the [Air Gap Install](https://longhorn.io/docs/1.3.2/advanced-resources/deploy/airgap/#using-a-helm-chart) guide.

```bash
# kubectl apply
helm repo add longhorn https://charts.longhorn.io
helm repo update
helm upgrade -i longhorn longhorn/longhorn --namespace longhorn-system --create-namespace --set ingress.enabled=true --set ingress.host=longhorn.$NUM.rancherfederal.training

# to verify that longhorn is the default storage class
kubectl get sc

# add encrypted storage class
kubectl apply -f https://raw.githubusercontent.com/clemenko/k8s_yaml/master/longhorn_encryption.yml

# go to page
echo "---------------------------------------------------------"
echo " control/command click : http://longhorn.$NUM.rancherfederal.training"
echo "---------------------------------------------------------"

# Watch it coming up
watch kubectl get pod -n longhorn-system
```

Once everything is running we can move on.

## Rancher NeuVector

If we have time we can start to look at a security layer tool for Kubernetes, https://neuvector.com/. They have fairly good [docs here](https://open-docs.neuvector.com/).

Note we are installing online for speed. Please see the [Air Gap Install](https://longhorn.io/docs/1.3.2/advanced-resources/deploy/airgap/#using-a-helm-chart) guide.

```bash
helm repo add neuvector https://neuvector.github.io/neuvector-helm/
helm repo update

helm upgrade -i neuvector --namespace neuvector neuvector/core --create-namespace  --set imagePullSecrets=regsecret --set k3s.enabled=true --set k3s.runtimePath=/run/k3s/containerd/containerd.sock --set manager.ingress.enabled=true --set manager.ingress.host=neuvector.$NUM.rancherfederal.training

# go to page
echo "---------------------------------------------------------"
echo " control/command click : http://neuvector.$NUM.rancherfederal.training"
echo "---------------------------------------------------------"
```

The username is `admin`.
The password is `admin`.


## Gitea and Fleet

Why not add version control? If we have time.

```bash
helm repo add gitea-charts https://dl.gitea.io/charts/
helm repo update

helm upgrade -i gitea gitea-charts/gitea --namespace gitea --create-namespace --set gitea.admin.password=Pa22word --set gitea.admin.username=gitea --set persistence.size=500Mi --set postgresql.persistence.size=500Mi --set gitea.config.server.ROOT_URL=http://git.$NUM.rancherfederal.training --set gitea.config.server.DOMAIN=git.$NUM.rancherfederal.training --set ingress.enabled=true --set ingress.hosts[0].host=git.$NUM.rancherfederal.training --set ingress.hosts[0].paths[0].path=/ --set ingress.hosts[0].paths[0].pathType=Prefix

# wait for it to complete
watch kubectl get pod -n gitea
```

Once everything is up. We can mirror a demo repo.

```bash
# now lets mirror
curl -X POST 'http://git.'$NUM'.rancherfederal.training/api/v1/repos/migrate' -H 'accept: application/json' -H 'authorization: Basic Z2l0ZWE6UGEyMndvcmQ=' -H 'Content-Type: application/json' -d '{ "clone_addr": "https://github.com/clemenko/rke_workshop", "repo_name": "workshop","repo_owner": "gitea"}'

# go to page
echo "---------------------------------------------------------"
echo " control/command click : http://git.$NUM.rancherfederal.training"
echo "---------------------------------------------------------"
```

The username is `gitea`.
The password is `Pa22word`.

We need to edit fleet yaml : http://git.$NUM.rancherfederal.training/gitea/workshop/src/branch/main/fleet/gitea.yaml . Change "$NUM" to your student number.

Once edited we can add to fleet with:

```bash
# patch
kubectl patch clusters.fleet.cattle.io -n fleet-local local --type=merge -p '{"metadata": {"labels":{"name":"local"}}}'
kubectl apply -f http://git.$NUM.rancherfederal.training/gitea/workshop/raw/branch/main/fleet/gitea.yaml
```

## Questions/Comments

Workshop Completed! Nice. How do we feel?