## Resource Reservations in AKS
- The compute needs of your applications are mostly related to CPU and memory.
- Before deciding about scaling your nodes or setting limits and requests, we will need to understand what AKS resources are needed to ensure the proper functionality of the nodes.
- `Limits` are the maximum amount of resources that can be used, and `requests` are the minimum guaranteed amount that is being reserved for the container.
- For a node, the limits can be overcommitted, which means over 100%, but requests cannot be more than 100%. Requests are relevant for scheduling decisions.
- AKS uses node resources to help the node operate as a component of your cluster.
- The total resources on your node and the resources that are really allocatable in AKS differ as a result of this usage. While establishing limits and requests for user-deployed pods, keep this information in mind.
- We can use `kubectl describe node <node-name>` to find a node's total capacity and allocate resources by looking under the capacity and allocatable fields.

### CPU Reservation Calculation

- Reserved CPU depends on the number of cores on the host as per the provided table.
- For example, if the node has two cores, 100 Milli cores will be reserved by AKS.
- Let's describe one of our nodes and see that and do the math.

```bash
Capacity:
  cpu:                2
  ephemeral-storage:  129886128Ki
  hugepages-1Gi:      0
  hugepages-2Mi:      0
  memory:             7116264Ki
  pods:               110
Allocatable:
  cpu:                1900m
  ephemeral-storage:  119703055367
  hugepages-1Gi:      0
  hugepages-2Mi:      0
  memory:             4670952Ki
  pods:               110
```

- We can see here capacity, which is the actual capacity, and the allocatable one.
- With respect to CPU, we are using SKU standard_Ds2_v2, which has two cores. As per the table, 100 Milli cores are reserved from these two vCPUs, which means that 1.9 vCPU cores are left allocatable.

### Memory Reservation Calculation
- Then we have memory (RAM), and its reservation is the sum of two values.
- The first one is the Kubelet daemon, which is by default installed on all nodes to manage container creation and termination.
- A node must always have at least 750MB allocatable by default on AKS due to the `kubelet daemon's memory available 750MB eviction rule`.
- Running pods will be terminated by the KUBELET to free up memory on the host machine when a host falls below that threshold for available memory.
- The second aspect is that for the Kubelet daemon to run effectively, there must be a regressive rate of memory reservation as per the provided table. It is important to understand that these resource reservations can be changed.
- Please note that the underlying node reserves some CPU and memory resources for maintenance in addition to the reservations for Kubernetes itself.
### Memory Reservation Calculation Example
- Let's do the math with respect to memory as well.
- We can see here, 7GB is the capacity of our node. However, if we check in the allocatable capacity, there is only 4.7 GB.
- So the math is, 0.75 GB is for the `kubelet daemon memory available rule`, + 0.25 GB * 4 because for the first 4 GB of memory, 25% is taken by the regressive rate of memory reservation, + 0.20 GB * 3 for the other three gigabytes of our node, which equals to 0.75 GB + 1GB + 0.6 GB 0.6GB, and the total is 2.35GB reserved from the total of seven gigabytes capacity on the node.
- That means that 33.57% of the memory is reserved by AKS.


## Scaling Nodes in AKS
Scaling of nodes in AKS should be done on the nodepool level
- AKS dashboard -> nodepools -> select nodepool -> increase node count -> apply

## Scale Down Modes in AKS
- By default, nodes get removed when you scale down, and new nodes are provisioned during scale-up operations, whether they are carried out manually or automatically by the cluster autoscaler.
- You can choose whether to delete or deallocate the nodes in your cluster after scaling down by using the `Scale-down` mode. Delete is the default mode. The other option is deallocate mode.
- The decision on choosing between delete or deallocate is based on the time needed to get the node ready to serve your workload. If you use deallocate mode, the node will not be removed, but it will just be stopped. This will result in faster scaling operations, providing you a node to host your application quickly. Another advantage is that with deallocate mode, the container images will be preserved on the node, whereas with delete mode, everything is deleted, and a new node is created, taking time to pull the images.

### Advantages of Deallocate Mode

- Deallocate mode allows for faster scaling operations.
- Container images are preserved on the node.

### Disadvantages of Deallocate Mode

- You will be charged for the operating system and any data storage disks attached to the VM, even if your nodes are deallocated or stopped.

### Important Considerations
- After you scale down a node, it will appear as not ready at the Kubernetes level.
- Ephemeral disks are not supported for scale-down mode deallocate, so you will need to use managed disks.
- You can create a node pool with any scale-down mode, and you can also update the scale-down mode after the node pool creation.
- If you have a node pool in deallocate mode and there are some deallocated nodes, switching to delete mode will remove the deallocated nodes.

**Adding Node Pools with Deallocate Mode**
```bash
az aks nodepool add --node-count 2 --scale-down-mode Deallocate --node-osdisk-type Managed --max-pods 10 --name nodepool2 --cluster-name myAKSCluster --resource-group myResourceGroup
```
- In the above command, we specify a node count of two and use deallocate mode for scaling down. We also specify the managed OS disk type.

**Observations After Scaling Down**
- When the node pool is added, go to the Azure Portal and scale down to 1 from 2.
- Observations: Go to the Infrastructure Resource Group, VMSS, and the instances. You will see, the instance is in the updating state and it will get in the allocated or stopped state. After some time, we see our node is in the stopped/deallocated state.

**Changing Scale-Down Mode to Delete**
```bash
az aks nodepool update --scale-down-mode Delete --name nodepool2 --cluster-name myAKSCluster --resource-group myResourceGroup
```

## Cluster Autoscaler
Cluster Autoscaler is a component used to automatically adjust the number of nodes within the cluster to run the cluster effectively and economically.

- ### Scaling Up
  - Cluster Autoscaler monitors pods in the cluster that cannot be scheduled due to resource constraints.
  - When scheduling pods becomes difficult due to resource constraints, the number of nodes in a node pool is increased to meet application demand.
  - Unschedulable pods trigger the Cluster Autoscaler to attempt to find new places to run them.
  - For example, if a pod needs more memory than is available on any cluster node, it becomes unschedulable.
  - Cluster Autoscaler checks for unschedulable pods every 10 seconds by default.

- ### Scaling Down
  - Nodes are periodically assessed for the absence of running pods and might be removed if necessary.
  - Cluster Autoscaler checks for resource utilization on nodes for scaling down, typically every ten seconds.
  - A node is considered for scaling down if the total CPU and memory used by all pods running on the node is less than 50% of the node's available resources.
  - The `--scale-down-utilization-threshold` flag configures the utilization threshold.
  - Pods running on the node, except for manifest-run pods or daemonset pods, can be transferred to other nodes.
  - Cluster Autoscaler is aware of possible destinations for each pod to be moved.
  - There are exceptions and configurations to consider, such as annotations on nodes to prevent removal or pod disruption budgets restricting eviction.
  - A node is removed if it is unneeded for more than ten minutes by default, configurable with the `--scale-down-unneeded-time` flag.
  - A configmap named `cluster-autoscaler-status` is added to the kube-system namespace to reflect the status of Cluster Autoscaler.

```bash
# enable cluster autoscaler while createing the cluster
az aks create -g <rg-name> -n <aks-name> --node-count 1 --enable-cluster-autoscaler --min-count 1 --max-count 3

# Enable the cluster autoscaler on an existing cluster
az aks update -g <rg-name> -n <aks-name> --enable-cluster-autoscaler --min-count 1 --max-count 3

# Disable the cluster autoscaler on a cluster
az aks update -g <rg-name> -n <aks-name> --name myAKSCluster --disable-cluster-autoscaler

# create a nodepool wuth autoscaler (-c is node count needed when the command executes)
az aks nodepool add -g <rg-name> -cluster-name <aks-name> --name cas-nodepool --enable-cluster-autoscaler --min-count 1 --max-count 5 -c 1

# Use the cluster autoscaler on node pools
az aks nodepool update -g <rg-name> -n <aks-name> --name nodepool1 --update-cluster-autoscaler --min-count 1 --max-count 5
```

(watch video for live action )
