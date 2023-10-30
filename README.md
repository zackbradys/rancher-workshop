![rgs-rancher-banner](images/rgs-rancher-banner.png)

# Rancher Government Solutions Workshop

### Table of Contents
* [About Me](#about-me)
* [Introduction](#introduction)
* [Workshop Outcomes](#workshop-outcomes)
* [Infrastructure](#infrastructure)
* [Rancher RKE2](#rancher-rke2)
* [Rancher Multi Cluster Manager](#rancher-multi-cluster-manager)
* [Rancher Longhorn](#rancher-longhorn)
* [Rancher NeuVector](#rancher-neuvector)
* [Rancher Fleet and Gitea](#rancher-fleet-and-gitea)
* [Questions and Comments](#questions-and-comments)

## About Me
A little bit about me, my history, and what I've done in the industry.
- Former Contractor
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

## Workshop Outcomes
*	Ability to Configure, Deploy, and Install Rancher Kubernetes (RKE2), Rancher Multi-Cluster Manager, Rancher Longhorn, and Rancher NeuVector.
*	Ability to Configure/Deploy Rancher Fleet and GitOps integration within Kubernetes clusters (Fleet <-> Gitea).
*	Understanding of the complexities and challenges within Kubernetes and the simplicity with Rancher.
*	Understanding of the Cluster and Application Lifecycle Management within Kubernetes clusters.
*	Understanding of the best practices around Infrastructure As Code (IaC), Security, and Compliance.

## Infrastructure

### Prerequistes

* Basic Linux Command Line Skills
* Familiarity with a Text Editor (VSCode)
* ASK QUESTIONS!!! PARTICIPATE!!

### Student Environment Signup

http://workshop-signup.rancherfederal.io

### Access the Environment

Access URL: `http://student$NUMa.rancherfederal.training:8080`

Password = `Pa22word`

Once logged into code server for **`studenta`**, open the menu in the top left corner, click on terminal, then click on new terminal two times.

```bash
### In the second terminal type:
## enter Pa22word
ssh $studentb
```

```bash
### In the second terminal type:
## enter Pa22word
ssh $studentc
```

```bash
### Example URLS in the Workshop:
VSCode --> http://student1a.rancherfederal.training
Rancher --> https://rancher.1.rancherfederal.training
Longhorn --> https://longhorn.1.rancherfederal.training
NeuVector --> https://neuvector.1.rancherfederal.training
Gitea --> https://git.1.rancherfederal.training
```

### DISA STIGS?!!

You can download the Official DISA STIGs for Rancher RKE2 and the Rancher Multi Cluster Manager below. For this workshop, we will be using all the latest controls.
* [RGS_RKE2_V1R2_STIG](https://dl.dod.cyber.mil/wp-content/uploads/stigs/zip/U_RGS_RKE2_V1R2_STIG.zip)
* [RGS_MCM_V1R2_STIG](https://dl.dod.cyber.mil/wp-content/uploads/stigs/zip/U_RGS_MCM_V1R2_STIG.zip)
* [DISA STIG Viewer](https://public.cyber.mil/stigs/srg-stig-tools/)

If you're curious to learn more about them, there is a nice article about it from [Businesswire](https://www.businesswire.com/news/home/20221101005546/en/DISA-Validates-Rancher-Government-Solutions%E2%80%99-Kubernetes-Distribution-RKE2-Security-Technical-Implementation-Guide).
We even have a tl:dr [here](https://github.com/clemenko/rancher_stig)!

## Rancher RKE2

If you are bored you can read the [docs](https://docs.rke2.io/). *Note we are installing the connected method for speed.*

We have another guide and git repository with all the air-gapping instructions [https://github.com/clemenko/rke_airgap_install](https://github.com/clemenko/rke_airgap_install). Including an easy way to test the full stack airgapped!

### studenta

Copy and paste the commands below on the **`studenta`** server. Make sure to take your time, some can take a few minutes! Here's where we can talk about the configuration options and how RKE2 works behind the scenes.

```bash
### Setup RKE2 Server
mkdir -p /opt/rke2-artifacts/ /etc/rancher/rke2/ /var/lib/rancher/rke2/server/manifests/
useradd -r -c "etcd user" -s /sbin/nologin -M etcd -U

### Configure RKE2 Config
cat << EOF >> /etc/rancher/rke2/config.yaml
#profile: cis-1.23
selinux: true
secrets-encryption: true
write-kubeconfig-mode: 0640
use-service-account-credentials: true
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
token: RGSsuperduperfunWorkshop
EOF

### Configure RKE2 Audit Policy
cat << EOF >> /etc/rancher/rke2/audit-policy.yaml
apiVersion: audit.k8s.io/v1
kind: Policy
rules:
- level: RequestResponse
EOF
```

```bash
### Download and Install RKE2 Server
### Install Options --> https://docs.rke2.io/install/install_options/server_config/
curl -sfL https://get.rke2.io | INSTALL_RKE2_CHANNEL=v1.25 INSTALL_RKE2_TYPE=server sh -

### Enable and Start the RKE2 Server
systemctl enable --now rke2-server.service
```

```bash
### Wait and Add Links
sudo ln -s /var/lib/rancher/rke2/data/v1*/bin/kubectl /usr/bin/kubectl
sudo ln -s /var/run/k3s/containerd/containerd.sock /var/run/containerd/containerd.sock
export KUBECONFIG=/etc/rancher/rke2/rke2.yaml
export PATH=$PATH:/var/lib/rancher/rke2/bin:/usr/local/bin/

### Verify RKE2 Kubectl
kubectl get nodes -o wide
```

### studentb and studentc

Let's copy and paste the commands below on the **`studentb`** and **`studentc`** server. Notice how we are configuring and install the RKE2 Agent versus the RKE2 Server. These should be fairly quick!

```bash
### Setup RKE2 Agent
mkdir -p /etc/rancher/rke2/

### Configure RKE2 Config
cat << EOF >> /etc/rancher/rke2/config.yaml
#profile: cis-1.23
selinux: true
write-kubeconfig-mode: 0640
kube-apiserver-arg:
- authorization-mode=RBAC,Node
kubelet-arg:
- protect-kernel-defaults=true
- read-only-port=0
- authorization-mode=Webhook
server: https://student${NUM}a.${DOMAIN}:9345
token: RGSsuperduperfunWorkshop
EOF
```

```bash
### Download and Install RKE2 Agent
### Install Options --> https://docs.rke2.io/install/install_options/linux_agent_config/
curl -sfL https://get.rke2.io | INSTALL_RKE2_CHANNEL=v1.25 INSTALL_RKE2_TYPE=agent sh -

### Enable and Start the RKE2 Agent
systemctl enable --now rke2-agent.service
```

## Rancher Multi Cluster Manager

Now let's move on to installing the management layer of Rancher, known as the [Rancher Multi-Cluster Manager](https://rancher.com/products/rancher). Head back to the **`student1a`** server and copy and paste the commands below.

*Note we are installing the connected method for speed. Please see the [Rancher Manager - Air Gap Install Guide](https://ranchermanager.docs.rancher.com/pages-for-subheaders/air-gapped-helm-cli-install).*

```bash
### Add Required Helm Repos
helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
helm repo add jetstack https://charts.jetstack.io
helm repo update

### Create the Cert Manager Namespace and Install Cert Manager
kubectl create namespace cert-manager

helm upgrade -i cert-manager jetstack/cert-manager --namespace cert-manager --set installCRDs=true

sleep 10

### Verify the status of Cert Manager
kubectl get pods --namespace cert-manager

### Create the Rancher Namespace and Install Rancher
kubectl create namespace cattle-system

helm upgrade -i rancher rancher-latest/rancher --namespace cattle-system --set replicas=1 --set auditLog.level=2 --set auditLog.destination=hostPath --set bootstrapPassword=Pa22word --set hostname=rancher.$NUM.$DOMAIN

sleep 30

### Verify the status of the Rancher Manager
kubectl get pods --namespace cattle-system

### Open the Rancher Manager
echo ""
echo " control/command click --> https://rancher.$NUM.$DOMAIN"
echo ""
```

The username will be **`admin`** and the password will be **`Pa22word`**.

## Rancher Longhorn

One the easiest ways to have stateful storage on this cluster is using [Rancher Longhorn](https://rancher.com/products/longhorn). Not only does it intergrate really well, but it provides a lot of functionality with little configuration. Let's deploy it. Head back to the **`student1a`** server and copy and paste the commands below.

*Note we are installing the connected method for speed. Please see the [Longhorn - Air Gap Install Guide](https://longhorn.io/docs/1.5.1/advanced-resources/deploy/airgap/).*

```bash
### Add Required Helm Repos
helm repo add longhorn https://charts.longhorn.io
helm repo update

### Create the Longhorn Namespace and Install Longhorn
kubectl create namespace longhorn-system

helm upgrade -i longhorn longhorn/longhorn --namespace longhorn-system --set ingress.enabled=true --set ingress.secureBackends=true --set ingress.host=longhorn.$NUM.$DOMAIN

# Verify that Longhorn is the default storage class
kubectl get sc

sleep 40

### Let's add an Encrypted Storage Class!
kubectl apply -f https://raw.githubusercontent.com/clemenko/k8s_yaml/master/longhorn_encryption.yml

### Verify the status of Longhorn
kubectl get pods --namespace longhorn-system

### Open the Longhorn Dashboard
echo ""
echo " control/command click --> https://longhorn.$NUM.$DOMAIN"
echo ""
```

There should be no username or password.

## Rancher NeuVector

Finally, let's deploy the security layer of Rancher, known as [Rancher NeuVector](https://neuvector.com). Head back to the **`student1a`** server and copy and paste the commands below.

*Note we are installing the connected method for speed. Please see the [NeuVector - Air Gap Install Guide](https://open-docs.neuvector.com/deploying/airgap).*

```bash
### Add Required Helm Repos
helm repo add neuvector https://neuvector.github.io/neuvector-helm/
helm repo update

### Create the NeuVector Namespace and Install NeuVector
kubectl create namespace cattle-neuvector-system

helm upgrade -i neuvector neuvector/core --namespace cattle-neuvector-system --set k3s.enabled=true --set k3s.runtimePath=/run/k3s/containerd/containerd.sock --set manager.ingress.enabled=true --set controller.pvc.enabled=true --set global.cattle.url=https://rancher.$NUM.$DOMAIN --set controller.ranchersso.enabled=true --set rbac=true --set psp=true --set manager.ingress.host=neuvector.$NUM.$DOMAIN

sleep 30

### Verify the status of NeuVector
kubectl get pods --namespace cattle-neuvector-system

### Open the NeuVector Dashboard!
echo ""
echo " control/command click --> https://neuvector.$NUM.$DOMAIN"
echo ""
```

The username will be **`admin`** and the password will be **`admin`**.

## Rancher Fleet and Gitea

Why not test out Rancher Fleet and add our own version control? If we have some extra time.

To deploy Gitea, head back to the **`student1a`** server and copy and paste the commands below.

```bash
### Add Required Helm Repos
helm repo add gitea-charts https://dl.gitea.io/charts/
helm repo update

### Create the Gitea Namespace and Install Gitea
kubectl create namespace gitea-system

helm upgrade -i gitea gitea-charts/gitea --namespace gitea-system --set gitea.admin.password=Pa22word --set gitea.admin.username=gitea --set persistence.size=1Gi --set postgresql.persistence.size=1Gi --set gitea.config.server.ROOT_URL=http://git.$NUM.$DOMAIN --set gitea.config.server.DOMAIN=git.$NUM.$DOMAIN --set ingress.enabled=true --set ingress.hosts[0].host=git.$NUM.$DOMAIN --set ingress.hosts[0].paths[0].path=/ --set ingress.hosts[0].paths[0].pathType=Prefix

sleep 50

### Verify the status of Gitea
kubectl get pods --namespace gitea-system

### Open the Gitea Dashboard!
echo ""
echo " control/command click --> https://git.$NUM.$DOMAIN"
echo ""
```

The username will be **`gitea`** and the password will be **`Pa22word`**. Once everything is running, we can mirror a demo repo!

After Gitea finishes deploying, head back to the **`student1a`** server and copy and paste the commands below.

```bash
### Mirror Workshop Git Repository
curl -X POST 'http://git.'$NUM'.'$DOMAIN'/api/v1/repos/migrate' -H 'accept: application/json' -H 'authorization: Basic Z2l0ZWE6UGEyMndvcmQ=' -H 'Content-Type: application/json' -d '{ "clone_addr": "https://github.com/zackbradys/rancher-workshop", "repo_name": "workshop","repo_owner": "gitea"}'
```

Before we deploy our GitRepo with Fleet, we need to edit our **`gitrepo.yaml`** and our **`app deployment yamls`** located at **`http://git.$NUM.rancherfederal.training/gitea/workshop/src/branch/main/fleet/gitea.yaml`**.

Update all occurances of **`"$NUM"`** to your student number.

Once we commit all changes, head back to the **`student1a`** server and copy and paste the commands below.

```bash
kubectl apply -f http://git.$NUM.$DOMAIN/gitea/workshop/raw/branch/main/fleet/gitea.yaml
```

## Questions and Comments

Workshop Completed! Nice. How do we feel? We'll review the workshop outcomes to see if we missed anything.
