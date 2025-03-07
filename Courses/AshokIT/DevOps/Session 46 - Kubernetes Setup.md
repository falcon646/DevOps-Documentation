
# Kubernetes Cluster Setup

1. **<u> Minikube </u>**: Minikube is a tool that allows you to run a single-node Kubernetes cluster on your local machine. It is ideal for development, testing, and learning purposes. Minikube provides an easy way to get started with Kubernetes without the need for a full-scale cluster.

2.	**<u>Kubeadm</u>**: Kubeadm is a command-line tool provided by the Kubernetes project for bootstrapping a cluster on your own infrastructure. It simplifies the setup process by handling the initialization of control plane components, joining worker nodes, and configuring networking. Kubeadm is commonly used for creating custom Kubernetes clusters on virtual machines or bare-metal servers.

3. **<u>Kubernetes as a Service (KaaS) </u>**: Some cloud providers offer managed Kubernetes services, which handle the cluster setup and management on your behalf. These services abstract away the underlying infrastructure and provide an easy way to deploy and scale Kubernetes clusters without worrying about the operational complexities. Examples include Amazon EKS, GKE, AKS, and DigitalOcean Kubernetes.


## Minikube Installation (session 46)
- OS : Amazon Linux 2023
- Type: t3.medium (2-CPU and 4-GB RAM)
- Istances : 1 

**[STOP INSTANCE AFTER YOUR USAGE IS DONE, IT IS A BILLABLE INSTANCE]**

```bash
# Install Docker
sudo yum update -y
sudo yum install docker -y
# Start and Enable Docker
sudo systemctl start docker
sudo systemctl enable docker

# Add Current user to docker group
sudo usermod -a -G docker $USER
sudo systemctl status docker

# Exit from current session and re-connect


# Download and Install Kubectl Client
sudo curl --silent --location -o /usr/local/bin/kubectl https://dl.k8s.io/release/$(curl --silent --location https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl
sudo chmod +x /usr/local/bin/kubectl
kubectl version --client

# Download and Install Minikube Software
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

# Start Minikube software
minikube start

# Check Installation status using these commands
minikube status
minikube version
kubectl version --short
kubectl cluster-info
kubectl get nodes

# If you stop and start your EC2 Instance then you need to start again Minikube software

# Check minikube status 
$ minikube status
# start minimuke
$ minikube start
```

# Kubeadm Installation (session 47)
- os   : Ubuntu 20.04 LTS:
- Type : t3.medium (2-CPU and 4-GB RAM) 
- Instances : 3 (1 master , 2 worker)
- ports:
    - 22 for ssh
    - all tcp ports - open anywhere

**[STOP INSTANCE AFTER YOUR USAGE IS DONE, IT IS A BILLABLE INSTANCE]**

Follow below steps in all instances(master and wroker) 
```bash
# Upgrade apt packages
sudo apt-get update

# Create configuration file for containerd:
cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf overlay br_netfilter 
EOF

# Load modules:
sudo modprobe overlay
sudo modprobe br_netfilter


# Set system configurations for Kubernetes networking:
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

# Apply new settings:
sudo sysctl --system

# Install containerd:
sudo apt-get update && sudo apt-get install -y containerd

# Create default configuration file for containerd:
sudo mkdir -p /etc/containerd

# Generate default containerd configuration and save to the newly created default file:
sudo containerd config default | sudo tee /etc/containerd/config.toml

# Restart containerd to ensure new configuration file usage:
sudo systemctl restart containerd

# Verify that containerd is running (optional)
sudo systemctl status containerd (presss q for exit)

# Disable swap:
sudo swapoff -a

# Disable swap on startup in /etc/fstab:
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# Install dependency packages.
sudo apt-get update && sudo apt-get install -y apt-transport-https curl

# Download and add GPG key.
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

# Add Kubernetes to repository list.
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

#	Update package listings
sudo apt-get update

#	Install Kubernetes packages (Note: If you get a dpkg lock message, just wait a minute or two before trying the command again)

sudo apt-get install -y  kubelet kubeadm kubectl kubernetes-cni nfs-common


# Turn off automatic updates:
sudo apt-mark hold kubelet kubeadm kubectl kubernetes-cni nfs-common
```

Master Node Setup
```bash
# Initialize the Cluster
sudo kubeadm init

# Set kubectl access:
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config


# Test access to cluster:
kubectl get nodes


# Install the Calico Network Add-On - On the Control Plane Node, install Calico Networking:
# [check for the latest here: https://github.com/projectcalico/calico/blob/master/manifests/calico.yaml]
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/master/manifests/calico.yaml


# list the workner nodes attached to the cluster
kubectl get nodes


# generate the join commands to join the Worker Nodes to the cluster
$ kubeadm token create --print-join-command
```
- Note : In both Worker Nodes, paste the output of the previos command to join them to the cluster. Use sudo to run it as root:

    ```sudo kubeadm join <token> ```

In the Control Plane Node, view cluster status (Note: You may have to wait a few moments to allow all nodes to become ready)
```bash
# Validate the setup by executing below command in master-node
$  kubectl get nodes
```
