# Index
1. [**Network Plugins:**](#network-plugin)
   - [Kubenet network plugin](#kubenet)
   - Azure CNI network plugin
   - Azure CNI overlay network plugin
2. **Network Plugin Comparison:**
   - Network plugins comparison
3. **Integration with Virtual Networks (VNET):**
   - Bring your own VNET/subnet, NSG and Route Table in AKS
4. **Load Balancer Services:**
   - A deeper look into LoadBalancer Service in AKS
   - Kubernetes Internal Load Balancer
   - Use an Azure Private Link service to connect to an internal load balancer
5. **Network Security:**
   - Considerations when multiple NSGs are used
   - SNAT in Azure
   - Outbound types: Load Balancer, NAT Gateway, and UserDefined Routing (UDR)
6. **Advanced Networking Configurations:**
   - Create AKS with NAT Gateway
   - Create AKS with UDR and Azure Firewall
   - Learn how AKS works with HTTP Proxy
   - Install mitmproxy on a VM
   - Deploy an AKS cluster with HTTP Proxy
   - Explore, update, and troubleshoot AKS with HTTP Proxy
7. **Networking Features:**
   - Understand VNET Peering
---
# Network Plugin
a network plugin is a component responsible for managing networking capabilities within the Kubernetes cluster. It enables communication between different pods (containers) and external services, assigns IP addresses to pods, and handles network policies and routing.

The network plugin in AKS ensures:
- **IP Address Management**: It assigns unique IP addresses to each pod within the cluster, facilitating communication between pods and external services.
- **Network Isolation**: It ensures that pods are isolated from each other and from external networks to prevent unauthorized access and maintain security.
- **Routing and Traffic Management**: It manages network routes to ensure efficient and secure routing of traffic between pods and external services.
- **Load Balancing**: It may handle load balancing to distribute incoming traffic across multiple instances of a service or application for scalability and fault tolerance.
- **Network Policies**: It enforces network policies to control traffic flow between pods based on labels, selectors, and other criteria, thereby enhancing security within the cluster.

### Types of Network Plugins for AKS
[Comparison](https://inder-devops.medium.com/aks-networking-deep-dive-kubenet-vs-azure-cni-vs-azure-cni-overlay-a51709171ce9)
- **kubenet**: This is the default network plugin used in AKS clusters. It provides basic networking functionality using Linux bridge and IP tables. Kubenet is simple to set up and suitable for small-scale deployments or testing scenarios. However, it may not offer advanced networking features or performance optimizations compared to other plugins.

- **Azure CNI (Container Networking Interface)**: is a network plugin that integrates tightly with Azure networking infrastructure. It assigns Azure VNet IP addresses directly to pods, enabling better performance and tighter integration with other Azure services. Azure CNI is well-suited for production workloads requiring high performance, scalability, and advanced networking features.

- **Azure CNI with Overlay** : provides the benefits of both Azure CNI and overlay networking, including high performance, scalability, advanced networking features, and seamless pod-to-pod communication across nodes in the AKS cluster. It is suitable for scenarios where workload isolation, scalability, and performance are essential requirements.
---
# Kubenet
KubeNet provides networking capabilities crucial for the operation of Kubernetes clusters, including pod-to-pod communication and service discovery.
It enables seamless communication between pods across different nodes in the cluster.
- **Node IP Addresses:** Nodes in AKS are assigned IP addresses from the subnet, enabling communication with other nodes and devices in connected networks.
- **Pod IP Addresses:** Pods, on the other hand, are assigned IP addresses from a logical address space known as the Pod CIDR.
- **Intra-Node Communication:** Communication between pods on the same node is managed locally, using routing tables (for IP addresses) and ARP caches (for mac address).
- **Inter-Node Communication:** Pods on different nodes communicate through an Azure route table assigned at the subnet level.
- **Inter Network Coomunication:** For communication beyond the Azure VNet, NAT is performed, translating pod IPs into node IPs.

**Note:** 
- Assigning a route table to the subnet is mandatory in AKS when using a subnet.
- AKS automatically manages routes in the route table when nodes are added or removed.

### Case Study
![alt text](images/kubenet-1.png)
- Consider the archicture from the picture . We have a aks cluster , with AKS VNET with IP range `10.224.0.0/12`
- Part of the VNET range is taken by the AKS subnet which is `10.224.0.0/16`
- In our example we have two nodes with ip's from the AKS subnet.
Node 0 has the IP address `10.224.0.4` where as the Node 1  has `10.224.0.4`
- On top of the subnet we have the Pod CIDR, which is a logical address with range `10.244.0.0/16`.
- The Pod CIDR is futher broken into smaller segments and assigned to the nodes(for the pods inside the nodes),
- Pods inside the Node 0 gets the range `10.244.0.0/24` and the Pods in Node 1 get the range `10.244.1.0/24`.
- If we would add another node , it would receive `10.244.2.0/24`. and so on. The pods receive IP addresses from these ranges based on the node that guest scheduled on.
- pod A in Node 0 receives the IP address `10.244.0.15` whereas Pod B in Node 0 receives the IP address `10.244.0.16`. Pod C in node 1 recieves the IP `10.244.1.27`
- **IP's Allocation**
   - **AKS VNet**: IP range 10.224.0.0/12
   - **AKS Subnet**: 10.224.0.0/16
   - **Pod CIDR**: 10.244.0.0/16
   - **Node IP Allocation**:
      - Node 0 IP: 10.224.0.4
      - Node 1 IP: 10.224.0.5
   - **Pod CIDR Allocation**:
      - **Node 0 Pods**: `10.244.0.0/24` (aks-nodepool1-11743156-vmss000000)
      - **Node 1 Pods**: `10.244.1.0/24` (aks-pool2-13111960-vmss000000)
      - Subsequent Nodes: (e.g., Node 2: 10.244.2.0/24)

### **Pod Communication on Same Node**
![intern](images/kubenet-2.png)

Now let's say Pod A wants to communicate with pod B which are on the same node.
- The node uses the `standard routing table` to determine the next hop for the packet because the destination IP is within the node's own pod range. 
- The kernel knows that the packet should be sent to the local network stack for processing. The local network stack uses the local ARP cache to determine the Mac address of the destination pod. (ARP stands for Address Resolution Protocol.)
- The ARP Cache maps the pod IP address to the MAC address of the network interface associated with the pod.
- Once the MAC address is resolved, the kernel forwards the packet to the network interface associated with the source port and the network interface transmits the packet to the destination network interface directly on the same node.
- So to summarize, he node uses the standard routing table and ARP to determine how to send traffic between pods within the same node.

Let's see this configuration within our cluster.
```bash
# get the nodes and their ip
kubectl get nodes -o wide

# note the ip's of the vms
NAME                                STATUS   ROLES   AGE   VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION      CONTAINER-RUNTIME
aks-nodepool1-11743156-vmss000000   Ready    agent   31m   v1.27.7   10.224.0.4    <none>        Ubuntu 22.04.3 LTS   5.15.0-1053-azure   containerd://1.7.5-1
aks-pool2-13111960-vmss000000       Ready    agent   20m   v1.27.7   10.224.0.5    <none>        Ubuntu 22.04.3 LTS   5.15.0-1053-azure   containerd://1.7.5-1
```
```bash
# get pods and their ip's of nodes
kubectl get pods -o wide | grep aks-nodepool1-11743156-vmss000000  

# check the ip addresses of the pods for aks-nodepool1-11743156-vmss000000 
nginx-deploy-846d6f46b7-6chl2                           1/1     Running     0          13m     10.244.0.14   aks-nodepool1-11743156-vmss000000   <none>           <none>
nginx-deploy-846d6f46b7-brfzg                           1/1     Running     0          13m     10.244.0.13   aks-nodepool1-11743156-vmss000000   <none>           <none>
nginx-deploy-846d6f46b7-j2sfj                           1/1     Running     0          13m     10.244.0.11   aks-nodepool1-11743156-vmss000000   <none>           <none>
nginx-deploy-846d6f46b7-qt67r                           1/1     Running     0          13m     10.244.0.12   aks-nodepool1-11743156-vmss000000   <none>           <none>
```
- from the output , we relalise that pods in node aks-nodepool1-11743156-vmss000000  are in the range `10.244.0.0/24`
```bash
# check the ip addresses of the pods for aks-pool2-13111960-vmss000000   
kubectl get pods -o wide | grep aks-pool2-13111960-vmss000000    
nginx-deploy-846d6f46b7-4dm97                           1/1     Running     0          15m     10.244.1.8    aks-pool2-13111960-vmss000000       <none>           <none>
nginx-deploy-846d6f46b7-dp6tl                           1/1     Running     0          15m     10.244.1.6    aks-pool2-13111960-vmss000000       <none>           <none>
nginx-deploy-846d6f46b7-qm6rw                           1/1     Running     0          15m     10.244.1.5    aks-pool2-13111960-vmss000000       <none>           <none>
nginx-deploy-846d6f46b7-snt2r                           1/1     Running     0          15m     10.244.1.7    aks-pool2-13111960-vmss000000       <none>           <none>
```
- from the output , we relalise that pods in node aks-pool2-13111960-vmss000000   are in the range `10.244.1.0/24`

- Now , accessing the node shell and running `ip route show` we see the node's internal routes.It displays the routing table, which includes entries added by kubenet for routing traffic between pods on the same node.
```bash
# aks-nodepool1-11743156-vmss000000 
/ # ip route show
default via 10.224.0.1 dev eth0  src 10.224.0.4  metric 100 
10.224.0.0/16 dev eth0 scope link  src 10.224.0.4  metric 100
10.224.0.1 dev eth0 scope link  src 10.224.0.4  metric 100
10.244.0.0/24 dev cbr0 scope link  src 10.244.0.1
168.63.129.16 via 10.224.0.1 dev eth0  src 10.224.0.4  metric 100
169.254.169.254 via 10.224.0.1 dev eth0  src 10.224.0.4  metric 100
```
- This line `10.244.0.0/24 dev cbr0 scope link  src 10.244.0.1` indicates that the traffic to `10.244.0.0/24` (the range assigned to this node) should be sent out via the `cbr` interface with a source IP of `10.244.0.1`. This is the network used by Kubenet to connect pods on the same node.

- If we run `arp -a"  , we see the ARP table. The output indicates the IP address and associated mac and interface.
```bash
# aks-nodepool1-11743156-vmss000000 
/ # arp -a
? (10.244.0.5) at 36:88:87:e8:f7:53 [ether]  on cbr0
? (10.244.0.8) at ca:b3:97:72:e1:ba [ether]  on cbr0
? (10.244.0.4) at 12:e5:86:2d:08:6f [ether]  on cbr0
? (10.244.0.15) at b6:a2:7c:ef:29:9e [ether]  on cbr0
? (10.244.0.7) at 12:47:9c:5a:76:03 [ether]  on cbr0
? (10.244.0.3) at 4e:ac:dd:aa:1a:04 [ether]  on cbr0
? (10.244.0.10) at 4a:1b:3a:13:4b:fb [ether]  on cbr0
? (10.244.0.6) at e6:08:61:26:ee:7e [ether]  on cbr0
? (10.244.0.2) at 46:ab:26:7f:e4:d5 [ether]  on cbr0
aks-pool2-13111960-vmss000000.internal.cloudapp.net (10.224.0.5) at 12:34:56:78:9a:bc [ether]  on eth0
? (10.244.0.9) at 8e:e4:75:47:c3:0f [ether]  on cbr0
? (10.224.0.1) at 12:34:56:78:9a:bc [ether]  on eth0
```
- When we analiyse the ip's present here , we see that all these ips are of the pods running on the aks-nodepool1-11743156-vmss000000 

- **DaemonSet Pods**
   - We also see that the ip address of some pods are not in the pod cidr range . they are in the range `10.224.x.x` , where as our pod cidr range is `10.244.x.x`
   - This is because these are pods associated with `daemonsets` that have specific privileges and `they have the IP address of the node they are running on`.
```bash
# grep pods with ip "10.224.x.x"
kubectl get pods -o wide -A | grep 10.224
#
kube-system   azure-ip-masq-agent-jldz9             1/1     Running   0          38m   10.224.0.5    aks-pool2-13111960-vmss000000       <none>           <none>
kube-system   azure-ip-masq-agent-zqxfm             1/1     Running   0          49m   10.224.0.4    aks-nodepool1-11743156-vmss000000   <none>           <none>
kube-system   cloud-node-manager-dj7zp              1/1     Running   0          49m   10.224.0.4    aks-nodepool1-11743156-vmss000000   <none>           <none>
kube-system   cloud-node-manager-j27w4              1/1     Running   0          38m   10.224.0.5    aks-pool2-13111960-vmss000000       <none>           <none>
kube-system   csi-azuredisk-node-xddth              3/3     Running   0          38m   10.224.0.5    aks-pool2-13111960-vmss000000       <none>           <none>
kube-system   csi-azuredisk-node-xwsqh              3/3     Running   0          49m   10.224.0.4    aks-nodepool1-11743156-vmss000000   <none>           <none>
kube-system   csi-azurefile-node-2nps6              3/3     Running   0          38m   10.224.0.5    aks-pool2-13111960-vmss000000       <none>           <none>
kube-system   csi-azurefile-node-vn2zg              3/3     Running   0          49m   10.224.0.4    aks-nodepool1-11743156-vmss000000   <none>           <none>
kube-system   kube-proxy-cvtcg                      1/1     Running   0          49m   10.224.0.4    aks-nodepool1-11743156-vmss000000   <none>           <none>
kube-system   kube-proxy-gmrvv                      1/1     Running   0          38m   10.224.0.5    aks-pool2-13111960-vmss000000       <none>           <none>
```

### **Communication between pods on Seperate Nodes**

![alt ext](images/kubenet-3.png)
- Next scenario is how would Pod A reach Pod C if they are scheduled on different nodes.
- The request from Pod A would go to Node 0 and here the `Azure route table` comes into picture.
- User defined routing (UDR)  and IP forwarding are used to determine the continuation of the traffic flow because Pod C has IP from  `10.244.1.0/24` and as per the route table, the packet will be sent to `10.224.0.5`, which is the IP of the Node 1 where the pod C resides.
- Further node 1 will internally use standard routing table and ARP to route the packet to Pod C (same as discussed in intranode communication of pods).
- To access the route table of a subnet
   ```bash
   -> goto Infra Resource group 
   -> slect vmss 
   -> slect the vnet 
   -> goto subnet 
   -> select the route table associated with the subnet 

   # az command to retrive route table details
   az network route-table route list --resource-group <resource-group-name> --route-table-name <route-table-name>
   ```

### **Pod Communication with Devices on same VNET or outside VNET**
- The next scenario is how the Pod C connect to a device on the same vnet or outside vnet. For example, in a peered vnet or onprem connected via VPN.
   - `10.224.1.2` : Ip of a device on the Same VNET
   - `10.1.2.3`   : Ip of a device on the another VNET/onPrem Network

- When the Pod C sends a request,it will be sent to Node 1 where NAT will be performed and then Node 1 will reach `10.1.2.3`
- The `10.1.2.3` device will see Node1's IP as the source traffic. Mostly the same process happens when it needs to reach a device `10.224.1.2` from the same VNET

![alat text](images/kubenet-4.png)

### When to Use Kubenet
- when you require few ips
- simplifying network management and avoiding conflicts with other resources.
- Kubenet doesn't require a large number of IP addresses, making it suitable for environments with limited address space
- Ideal for environments where most communication occurs within the cluster ie pod to pod, as it optimizes routing for internal traffic.

### Disadvantages of Kubenet
- Introduces minor latency due to additional network hops required for communication between pods on different nodes.
- Restricted by the Azure route table's maximum capacity of 400 routes, limiting the scalability of the cluster to 400 nodes.
- cannot with multiple Kubernetes clusters in the same subnet, restricting flexibility in cluster deployment and management.
- Doesn't support advanced features like Windows nodes, Azure Network Policy, or virtual nodes.

---
# [Azure CNI](https://learn.microsoft.com/en-us/azure/aks/concepts-network#azure-cni-advanced-networking) 
- Azure CNI (Container Networking Interface) is a networking plugin designed for Kubernetes clusters on Azure.
- aka Advanced networking plugin.
- It provides network isolation between pods & integrates with Azure VNETs for secure pod communication with other Azure resources.
- Optimized for high performance, ensuring low latency and high throughput.
- Dynamically manages IP address allocation for pods.
- Supports network policies for defining and enforcing network access control rules within the cluster.
- pod cidr doesnt exist

With Azure CNI there are 2 ways the of IP allocation 

**1. Traditional Allocation(default)**  

- in this method both nodes and pods get IP addresses from the subnet. 
- The ip's are pre-allocated and reserved for each node based on `maxPods` parameter.`maxPods` is used to specify the maximum number of pods that a node can host. (This is used for all aks cluster, irrespective of the networking plugin). 
- For example, if you set maxPods parameter to 30, each node will be allowed to host 30 pods. 
- Some pods like kube-proxy etc will have the same ip as the node's ips due to their privileges. 
- ie. 1 IP will be allocated for the node and the rest of IP'S will be available for the pods running on that node to accommodate 30 pods on that node.

**2. Dynamic Allocation of IP and Enhanced Subnet** 
- here the pods get IP's from a seperate dedicated pod subnet from the VNET. 
- while creating the cluster you need to pass the parameter `--pod-subnet`. 
- the Pods and Nodes have IP's from different subnet

### Communication between devices

- **Pod to Pod Communication** : will happen directly without any additional hop, irrespective of the fact if the pods are on the same node or not
- **Pod Communication with Devices on same VNET** : the device will see the Pod's IP as the source IP address
- **Pod Communication with Devices on outside the VNET** : the device will see node's IP (hosting the pod)  as the source address, but that can be changed by modifying the masquerade rules.

![alttext](images/azcni-1.png)

### Create AKS Cluster with Azure CNI network plugin
```
# specify an additional parameter `--network-plugin azure`
az aks create -g <rg-name> -n <aks-name> --network-plugin azure --node-count 2
```
[More Confuguration](https://learn.microsoft.com/en-us/azure/aks/configure-azure-cni?tabs=configure-networking-portal)
### Case Study

- **AKS VNET Range**   : 10.224.0.0/12
- **AKS Subnet Range** : 10.224.0.0/16
- **Node 0** : `10.224.0.4` to `10.224.0.32`
- **Node 1** : `10.224.0.33` to `10.224.0.61`
- Check the IP's allocated to the nodes
```bash
kubectl get nodes -o wide
# note the ip of the nodes
NAME                                STATUS   ROLES   AGE     VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION      CONTAINER-RUNTIME
aks-nodepool1-36884090-vmss000000   Ready    agent   9m43s   v1.27.7   10.224.0.4    <none>        Ubuntu 22.04.3 LTS   5.15.0-1053-azure   containerd://1.7.5-1
aks-nodepool1-36884090-vmss000001   Ready    agent   7m44s   v1.27.7   10.224.0.33   <none>        Ubuntu 22.04.3 LTS   5.15.0-1053-azure   containerd://1.7.5-1
```
- check the maxPods value from the nodePool overview on the Portal
- when we see the connected devices under the VNet from the Infra RG page , we can see that IP from 10.224.0.4 to 10.224.0.32 are for instance 0 where as IP's from 10.224.0.33 to 10.224.0.61 will be for instance 1.
- But there are only 28 ip's from 10.224.0.4 to 10.224.0.32, even through the maxpod on the node can be 30. This is because the maxPods params is for the number of pods and not the number of ips, since the pods associated with daemonsets also have the same ip as its nodes , hence they are counted in the number of pods but not in the number of ip's

### When to Choosing Azure CNI
- **minimal hops and lower latency** : since pods receive IPs from the subnet, enabling full virtual network connectivity and direct communication with connected networks using private IP addresses
- **No Need for User-Defined Routes:** Simplifies network management as there's no mandatory requirement for managing user-defined routes or assigning Azure route tables at the subnet level, unless for specific use cases.
- when the communication happens mostly with devices outside the cluster.
- when you need to have multiple clusters in the same subnet.
- CNI unlocks features like Windows nodes, Azure Network policy and virtual nodes.

### Disadvantages of Azure CNI

- **High IP Address Requirement:** Requires a significant number of IP addresses and careful IP address planning before cluster creation to avoid IP address exhaustion.

- **Buffer Node Requirement for Operations:** when you upgrade the Kubernetes version, an extra node is added during that operation, which will require one IP for itself and a few more for the pods based on the value of max pods parameter.

However, most of these Disadvantages are addressed by **Dynamic IP Allocation and Enhanced Subnets**

### **Dynamic IP Allocation and Enhanced Subnets**
- **Improved IP usage:** IP's are dynamically assigned to cluster pods compared to the traditional CNI method, which assigns static IP addresses to each node. This results in a cluster that uses its IP's more efficiently.
- **Flexibility & Scalability:** subnets for nodes and pods can be scaled separately.
- **Shared Pod Subnets:** Multiple nodepools of a cluster or multiple cluster deploying the same Vnet may share a single pod subnet.
- A node pool can also have its own pod subnet setup.
- **High Performance: ** due to shared pod subnets,  pods can directly communicate to other cluster pods and resources in the VNET since they are given VNET IP addresses.
- This approach allows extremely large cluster with no performance impact.

---
# [Azure CNI Overlay Network Plugin](https://learn.microsoft.com/en-us/azure/aks/azure-cni-overlay?tabs=kubectl)

- With Azure CNI Overlay, the cluster nodes are deployed into an Azure Virtual Network (VNet) subnet. Pods are assigned IP addresses from a private CIDR logically different from the VNet hosting the nodes. Pod and node traffic within the cluster use an Overlay network. Network Address Translation (NAT) uses the node's IP address to reach resources outside the cluster. 
- This solution saves a significant amount of VNet IP addresses and enables you to scale your cluster to large sizes. An extra advantage is that you can reuse the private CIDR in different AKS clusters, which extends the IP space available for containerized applications in Azure Kubernetes Service (AKS).