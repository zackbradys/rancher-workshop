### Rancher K3s

For Rancher K3s we are only going to look at the online installation method. Head to the **`student1a`** server and copy and paste the commands below.

```bash
### Download and Install K3s


### Enable and Start K3s


### Verify K3s Kubectl
kubectl get node -o wide
```

At this point you should see something similar to below.

```bash

```

Congratulations! You configured, deployed, and install a three node K3s (aka Kubernetes cluster). Not that hard right?

Skip to the [Rancher Multi-Cluster Manager](https://github.com/zackbradys/rancher-workshop/tree/main#rancher-multi-cluster-manager) step in the workshop. Rancher K3s replaces Rancher RKE2 as the underlying Kubernetes distribution and Kubernetes cluster.