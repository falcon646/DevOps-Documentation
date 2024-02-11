# 50.  Virtual Machine ScaleSets (VMSS) and Virtual Machine Availability Sets (VMAS)
**Virtual Machine Types:**
- Node pools in AKS can use two types of virtual machines:
    - Virtual Machine Scale Set (VMSS)
    - Virtual Machine Availability Set (VMAS)

1. **`Virtual Machine Availability Set (VMAS):`**
   - Represents a collection of discrete virtual machines.
   - Prevents single points of failure by dispersing VMs across fault domains and update domains.
   - **Update Domain:** Determines the number of VMs updated concurrently during planned maintenance (maximum of 20).
   - **Fault Domain:** Groups VMs sharing the same power source and network switch to mitigate network/power outages and hardware failures (maximum of 3).

2. **`Virtual Machine Scale Set (VMSS):`**
   - Collection of identical virtual machines deployed and maintained together.
   - Provides automatic scaling and management to meet fluctuating demand.
   - Default set type for node pools in AKS.

**Limitations:**
   - **Virtual Machine Availability Set:**
     - Only supports a single node pool.
     - Cluster autoscaler cannot be enabled.
   - **Virtual Machine Scale Sets:**
     - Deployed in a single fault domain, limiting fault tolerance.

```bash
# create a aks cluster with VMSS as the vm type (defaukt)
az aks create -g aks-rg -n aks-vmas-demo --node-count 2

# create a aks cluster with VMAS as the vm type
az aks create -g aks-rg -n aks-vmas-demo --vm-set-type AvailabilitySet --node-count 2
```
### AKS Cluster with VMAS vs VMSS
- navigate to the infrastructure resource group to analyse below resouces:
- In VMAS
     - seperate virtual machine and disksa associated with it
     - Network interfaces
     - `Availability set`
- Note that vm , disk and interface resources are seperate resouces in VMAS, unlike VMMS
- Availability set: In VMAS , VMs dispersed across fault domains and update .  we domains(select the availablityset to see that) but for VMSS : VMs are part of only one fault domain but multiple update domains.
    ```bash 
    ### Use commands to check VMs' update and fault domains.
    # view update domain of the vmss 
    az vmss get-instance-view --resource-group "<infra-rg>" --name "<vmss-name>" --instance-id "*" | grep platformUpdateDomain
    # view fault domain of the vmss 
    az vmss get-instance-view --resource-group "<infra-rg>" --name "<vmss-name>" --instance-id "*" | grep platformFaultDomain
    ```
- **Cluster Management:**
   - In the availability set cluster, we observe limitations:
     - No option to add a new node pool.
     - Scaling is possible but without autoscaler option; manual scaling only.

- **Conclusion:**
   - Virtual machine scale sets (VMSS) are the default choice in AKS for their flexibility and management advantages.
   - Availability set option provides fault tolerance but with limitations in scaling and autoscaling capabilities.

---
# 51. System and User Node Pools Types

**`System Node Pool`**
- Intended to host critical system pods whcih are responsible for core functionalities like coredns, konnectivity or metrics server.
- Ensures that system pods are isolated and efficiently managed within the AKS cluster.
- nodes under system nodepools are automatically labeled with `kubernetes.azure.com/mode:system`.
- This label helps in identifying and distinguishing nodes belonging to the system node pool.
- **Pod Scheduling:** : System pods are configured with nodeAffinity type `preferredDuringSchedulingIgnoredDuringExecution` whcih ensures matching with the `kubernetes.azure.com/mode=system` label during scheduling.
   ```bash
   # check the label on the node
   kubectl describe node | grep -i labels

   # check the nodeaffinity values in coredns pods
   kubectl describe pods <coredns-pod-name> -n kube-system -o yaml | grep -i "nodeAffinity"
   ```
- system node pool has to be linux
**`User Node Pool`:**
- Designed to host application pods, ensuring isolation from critical system components.
- Provides a suitable environment for deploying and managing user-specific workloads within the AKS cluster.
- To prevent application pods from scheduling on system node pools, a "no-schedule" taint(`CriticalAddonsOnly=true:NoSchedule`) is added at the system node pool level .
- System pods are configured with a toleration for this taint, allowing them to be scheduled on system nodes but not application pods.
   ```bash
   # Examine the toleration settings in the YAML output, which allow system pods to tolerate the "no-schedule" taint.
   kubectl get pod coredns-xxxx -n kube-system -o yaml | grep -i tolerations
   ``` 
- user node pool can be linux/windows
**`Summary`:**
- While not mandatory, segregating system and application workloads between separate node pools is a recommended best practice.
- Adding a "no-schedule" taint to system node pools can prevent application pods from scheduling on them but it is not mandatory
- At least one system node pool is required in an AKS cluster, but it's permissible for it to host both system and application pods.

![alt text](../images/image9.png)

**Node Pool Type Conversion:**
- It is possible to convert the type of a node pool from system to user or vice versa in AKS.
- The conversion is allowed only if there is at least one system node pool in the cluster.
- In a scenario with two node pools, one system and one user, the system node pool cannot be converted to a user node pool directly. However, the user node pool can be converted to a system node pool.
- To convert a system node pool to a user node pool:
     - Create a new system node pool if necessary.
     - Convert the existing user node pool to a system node pool.
     - Perform the conversion of the new system node pool to a user node pool.
     - Goto Nodepools -> select nodepool -> slect configuration -> change mode -> Apply

---
# 52. Connect to AKS Nodes using helper pod

**Accessing Nodes with kubectl Debug**
- Users often require direct access to nodes for troubleshooting, maintenance, or log collection purposes.
- `kubectl debug` is a tool that facilitates node access by creating helper pods with elevated privileges on targeted nodes.
```bash
# triggers the creation of a helper pod on the specified node.
kubectl debug node/<node-name> -it --image=mcr.microsoft.com/cbl-mariner/busybox:2.0

# get the yaml config of the helper pod
kubectl get pod <pod-name> -o yaml
```
- **YAML Configuration:** Delving into the YAML configuration of the helper pod provides insights into its capabilities and permissions.
    - `nodeName`: Specifies the targeted node for pod scheduling.
    - `hostIPC:true`: Allows the pod to access the host's Inter-process communication allowing it to communicate with other process on the host (use with caution as it interfering with other processes potentially poses a security risk)
    - `hostNetwork:true`: Permits the pod to share the node's network namespace, enabling direct access to network resources.
    - `hostPID:true`: Enables the pod to access the node's process namespace, facilitating interaction with node processes.
    - `volumeMounts`: Specifies volumes mounted into the pod's filesystem, including the `host root volume` for accessing the node's filesystem.

- **Security Considerations:**
  - Caution is advised when enabling features like `hostIPC`, `hostNetwork`, and `hostPID` due to potential security risks.
  - These features should be enabled only when necessary and with a thorough understanding of their implications.

**Accessing nodes with kubectl node-shell**
- Running `kubectl node-shell <node-name>` creates a helper pod named `nsenter` in the cluster.
- Execute `kubectl get pods <pod-name> -o yaml` to retrieve the YAML configuration of the `nsenter` pod.
   - `nodeName` and `hostNetwork`, `hostPID` parameters may be set to true similar on previous `kubectl debug` pod observations.
   - `privileged:true` flag grants elevated privileges to the container, potentially allowing root capabilities and risks.
    - The `nsenter` command section is a Linux tool enabling access to the environment of a process running inside the pod.
    - `--mount --uts --ipc --net --pid` options specify the namespaces to enter.
    - The `--bash -l` command starts a shell session within the specified namespaces, configuring the shell as a login shell.
      ```yaml
      containers:
      - command:
         - nsenter
         - --target
         - "1"
         - --mount
         - --uts
         - --ipc
         - --net
         - --pid
         - bash
         - -l
      ```
  - the command args mentioned allows entering the namespace of a running process, aiding in debugging and maintenance tasks.

---
# 53. Connect to AKS Nodes via SSH using Azure Bastion

By default, nodes in Azure environments lack public IP addresses, similar to VMs in a closed network setup.

**Traditional Approach: Jump Box**
  - Typically, a jump box with a public IP is deployed within the network to facilitate connections to VMs through SSH.
  - Maintenance overhead is associated with managing the jump box.

**Azure Bastion**
  - Azure Bastion serves as a fully managed platform-as-a-service resource tailored for secure connectivity to VMs or nodes.
  - It eliminates the need for a jump box by offering direct SSH connectivity to VMs/nodes without the requirement for agent installation or public IP assignment.
  - Azure Bastion is provisioned within a virtual network ensures immediate TLS encryption for enhanced security which provides secure communication channels between the user and VMs.


In our diagram, users leverage Azure Bastion to connect to VM instances securely. The Bastion NSG is applied to the Azure Bastion subnet, enhancing network security. While not mandatory, this configuration is advisable for better security practices. Additionally, SSH access should be allowed for connecting to Linux nodes, ensuring seamless connectivity and management across different operating systems.

![alt text](../images/image10.png)

**Steps to Set Up Azure Bastion for SSH Connectivity**

1. **Generate SSH Key Pair:** If you don't have an SSH key pair, create it
     ```
     ssh-keygen -m PEM -t rsa -b 4096
     ```
2. **Update Cluster Configuration:** Update the cluster settings to include the SSH public key for authentication.
     ```bash
     # install preview extension if not installed
     az extension add --name aks-preview
     # update preview extension
     az extension update --name aks-preview

     # update ssh keys on the cluster
     az aks update --name myAKSCluster --resource-group MyResourceGroup --ssh-key-value ~/.ssh/id_rsa.pub
     ```
3. **Create Azure Bastion Subnet:** create a subnet named "AzureBastionSubnet" in the AKS Vnet or any VNET with connectivity to the AKS VNET.
   - Goto Infra RG -> Select VNet -> Subnet -> Create New -> "Provide Name" -> Default CIDR -> Create.

4. **Provision Azure Bastion:** Create the Azure Bastion  within the "AzureBastionSubnet" subnet.
   - Goto "Bastion" -> Create -> Select rg -> Name "aks-bastion" -> select same resgion as aks -> select the vnet and subnet -> select "create new" public ip -> create

5. **Connect to VMs via Azure Bastion:**
   - Access the Azure Portal and navigate to the Infra RG.
   - Select VMSS -> Select the VM instance intended for connection via Azure Bastion.
   - Connect to the VM using the Azure Bastion with the following credentials:
     - Username: azureuser (default for Azure VMs)
     - Private Key: use the private key from the generated SSH key pair.

---
# 54. Connect to AKS Nodes via SSH using Pod

- We'll leverage a simple pod creation method to establish SSH connectivity to one of our nodes directly.
- This approach avoids the extra cost associated with provisioning additional Azure resources like subnets and Azure Bastion.

- **Prerequisite:**
  - Ensure you have an SSH key pair ready and updated in the aks cluster, as used in the Azure Bastion section.

1. **Deploy the pod:**
   - Deploy a pod with an OpenSSH client installed
   - This pod can be scheduled on any node within the cluster, regardless of the node you aim to SSH into.
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: ssh-pod
spec:
  containers:
  - name: ssh-pod
    image: nginx
    lifecycle:
      postStart:
        exec:
          command: ["/bin/bash", "-c", "apt-get update && apt-get install openssh-client vim sshpass -y"]
  nodeSelector:
    "kubernetes.io/os": linux
```

2. **Copying SSH Key:** - Use the `kubectl cp` command to copy the private SSH key from your local machine to the newly created pod.
   `kubectl cp ~/.ssh/id_rsa.pub <pod-name>:/id_rsa`

3. Enter the pod's shell environment using the `kubectl exec` command.

4. Exectute `ssh -i <path-to-private-key> azureuser@<node-name-or-ip>`

---
# 56. OS on AKS Nodes
**Ubuntu:**
   - **Ubuntu 18:** This is a popular distribution developed by Canonical. It serves as the default operating system for Linux nodes with Kubernetes version 1.24 or lower.
   - **Ubuntu 22:** This version is the default Linux OS for Kubernetes nodes running Kubernetes version 1.25 or higher. However, it will eventually be replaced as the default Linux OS for Azure Kubernetes Service (AKS) nodes by Azure Linux, also known as Mariner.

**Azure Linux (Mariner):**
   - Azure Linux is based on CBL-Mariner, which is Microsoft's Linux open-source distribution. It will become the default Linux OS in AKS, replacing Ubuntu 22.

It's important to note that users do not have the option to choose between Ubuntu versions 18 and 22; the selection is determined based on the Kubernetes version deployed in the cluster.

---
# 57. NodesPools with Azure Linux ([Mariner](https://learn.microsoft.com/en-us/azure/azure-linux/intro-azure-linux))

- Azure Linux, based on the CBL-Mariner operating system
- aka Mariner, is an open-source Linux distribution designed for various Azure services, including AKS.

**Key Features**:
  - prioritizes security, rapid issue resolution, and ease of management.
  - Lightweight and includes only essential packages required for running container workloads, reducing maintenance overhead and minimizing the attack surface.
  - has a Microsoft-hardened kernel customized for Azure at its base layer.
  - **Package Management**: Adopts the RPM package format, with TDNF serving as the package manager.
  - Azure Linux is generally available and deemed suitable for production environments.
  - Users have the option to create AKS clusters exclusively with Azure Linux during cluster creation or add Azure Linux node pools later,
   -  Its lightweight and secure nature makes Azure Linux a logical choice for containerized environments.

```bash
# create a system nodepool with azurelinux
az aks nodepool add -g <rg-name> --cluster-name <aks-name> --name <node-pool-name> --os-sku AzureLinux --mode System --node-count 1

# exec into the node to see the os version
cat /etc/os-release

# tdnf is the package manager
tdnf -h
tdnf update
tdnf install tcpdump -y 
```

---
# 59. Scheduling Pods on Specific NodePools
  - Various scheduling methods are available to efficiently manage pod placement within Kubernetes clusters.
  - Here , we will use NodeSelector
  - By utilizing labels on the node , we can direct Kubernetes to schedule pods on specific types of nodes based on the lables.
  - When examining node details with `kubectl get node` and `kubectl describe node`, we can observe the existing labels associated with each node.
  eg we can see the label on th node `agentpool=nodepool1`

**Node Selector**:
  - we add a `nodeSelector` section under spec in the pod template of deployment yaml.
  - The nodeSelector specifies a label (`agentpool: nodepool1` in this case) to indicate which nodes the pod should be scheduled on.
  - By applying this configuration, we ensure that pods created by the deployment are scheduled only on nodes labeled with `agentpool: nodepool1`
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: nginx-pool
  name: nginx-pool
spec:
  replicas: 5
  selector:
    matchLabels:
      app: nginx-pool
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: nginx-pool
    spec:
      containers:
      - image: nginx
        name: nginx
      nodeSelector:
        agentpool: nodepool1  # <label-name>: <lable-value>
```
---
# 60. Customize node configuration using az aks parameters

[Custom Node Configuration in AKS](https://learn.microsoft.com/en-us/azure/aks/custom-node-configuration?tabs=linux-node-pools)
  - By default, AKS sets values optimized for typical scenarios, but customization may be necessary to meet specific requirements.
  - kubelet , Socket and network, File handle limits , Virtual memory parameters can be adjusted during cluster and node pool creation
  - AKS offers options to modify specific parameters, allowing users to fine-tune settings according to their workload demands.
  - These customization options are only accessible during the creation of clusters and node pools within AKS.

**Customizing Kubelet Parameters**:
  - For instance, if the default value of `imageGcHighThreshold` is 85 and we wish to modify it, we can follow these steps.

- **Confirmation of Default Value**: To confirm the default value of a kubelet parameter, we can utilize the `kubectl proxy` to start the proxy server and on a different terminal use a curl request to fetch the configuration from a node. 
    ```
    curl -sSL "http://localhost:8081/api/v1/nodes/<node-name>/proxy/configz"
    ```

- **Modifying the default value**: we need to create a configuration file with the desired changes. Here , we want to set `imageGcHighThreshold` to 90, we create a JSON file named `linuxkubeletconfig.json` with the following content:
    ```json
    {
        "imageGcHighThreshold": 90
    }
    ```

- **Applying Configuration to Node Pool**:
  - We cannot directly modify existing nodes, but we can create a new node pool with the desired configuration.
  - Using the Azure CLI, we can add a new node pool to our AKS cluster and specify the custom kubelet configuration file.
    ```
    az aks nodepool add --name <node-pool-name> --cluster-name <aks-cluster-name> --resource-group <ResourceGroup-name> --kubelet-config ./linuxkubeletconfig.json
    ```
  - After creating the new node pool, we can verify that the parameter has been updated by fetching the configuration of one of the new nodes.
    ```
    curl -sSL "http://localhost:8081/api/v1/nodes/<node-name>/proxy/configz"
    ```

---
# 61. Customize node configuration using DaemonSet
  
- DaemonSets can be utilized to modify node configuration effectively.
  - For example we can adjust the `vm.max_map_count` setting for the kernel on each node.
  - `vm.max_map_count` is a critical parameter in Linux governing the maximum number of memory map areas a process can possess.
  - Below is the YAML for the DaemonSet:
    ```yaml
    apiVersion: apps/v1
    kind: DaemonSet
    metadata:
      name: modify-vm-max-map-count
      labels:
        app: modify-vm-max-map-count
    spec:
      selector:
        matchLabels:
          app: modify-vm-max-map-count
      template:
        metadata:
          labels:
            app: modify-vm-max-map-count
        spec:
          containers:
          - name: busybox
            image: busybox
            command: ["sh", "-c", "sysctl -w vm.max_map_count=65540 && sleep infinity"]
            securityContext:
              privileged: true
            hostPID: true
    ```
- **Explanation**:
  - This DaemonSet runs a BusyBox container.
  - The container's command adjusts the `vm.max_map_count` to a value close to the default and then sleeps indefinitely.
  - `privileged: true` enables the container to modify kernel settings.
  - `hostPID: true` grants access to the kernel settings of the host machine.


- **Determining Default Value of `vm.max_map_count`**:
   - **Access Node Shell**: use `kubectl node-shell` command to access the shell of the target node.
   - Execute the command `sysctl -a | grep vm.max_map_count` within the shell to retrieve the current value of `vm.max_map_count`.
- **Validation**:
  - We'll modify the `vm.max_map_count` setting to `65540` in the DaemonSet YAML file.
  - Apply the updated DaemonSet YAML to implement the configuration change and wait for the pods to come up.
  - Connect to the node again and inspect the value of `vm.max_map_count` to ensure it reflects the modification.
  - `note : the configuration changes will persist even if we delete the daemonset pods.`

- **Important Considerations**:
  - Changes to kernel settings can significantly impact system stability and performance.
  - It's crucial to thoroughly test any modifications before deploying them in a production environment.
  - Care should be exercised when modifying kernel settings, as incorrect values can adversely affect system stability and performance.

---
# 62. OS Disks for Nodes

### Managed Disk
  - A managed disk is a virtual hard disk in Azure, stored in an Azure storage account.
  - Primarily used to store the operating system and boot files for a virtual machine.
  
**Purpose**:
  - Provides persistent storage to prevent data loss during VM migration.
  - Azure automatically copies the VM's operating system disk to Azure storage for redundancy.

**Usage**:
  - Typically used for persistent storage needs.
  - Ensures data persistence across VM relocations or host migrations.
  
**Considerations**:
  - Not intended for persistent storage in containers due to associated disadvantages:
    - Lower node provisioning speed.
    - Higher read and write latency.
  
### Ephemeral Disk
  - A temporary disk managed by Azure on the local storage of the VM host.
  - Serves as a repository for VM boot and operating system files.
  
**Purpose**:
  - Provides temporary storage without persistence when the VM is stopped or relocated.
  - Offers lower read and write latency, faster node scalability, provisioning, and cluster upgrades.
  
**Usage**:
  - Ideal for stateless workloads that do not require permanent storage, such as web servers or container instances.
  - Included in the price of the virtual machine, reducing costs associated with additional storage.
  
### **Recommendations**:
  - Default choice when persistent storage is not required.
  - Preferred for Kubernetes pods requiring local storage persistence, utilizing EmptyDir or Hostpath volumes.

az aks nodepool add --name ephemeral --cluster-name <aks-name> --resource-group <rg-name> -s Standard_B4ms --node-osdisk-type Ephemeral --node-osdisk-size 30 --node-count 1
az aks nodepool add --name managed --cluster-name <aks-name> --resource-group <rg-name> -s Standard_B4ms --node-osdisk-type Managed --node-osdisk-size 30 --node-count 1

### Node Pool Creation and Comparison

`Ephemeral OS Disk Node Pool`
- **Configuration**:
  - **Disk Type**: Ephemeral
  - **Temporary Disk Space**: 32GB
  - **OS Disk**: 30GB
  - **Partition Details**:
    - OS Disk: 30GB
    - Temporary Disk (`sdb`): 2GB
- **Purpose**:
  - Utilizes temporary disk space for short-term workloads.
- **Management**:
  - Automatically managed by Azure on the local storage of the VM host.
- **Creation**:
  ```bash
  az aks nodepool add --name ephemeral --cluster-name <aks-name> --resource-group <rg-name> -s Standard_B4ms --node-osdisk-type Ephemeral --node-osdisk-size 30 --node-count 1
  ```
- **Observations**:
  - **Portal Configuration**: Disk size displayed as 30GB.
  - **CLI Verification**: 
    - Run `kubectl node-shell <node-name>` to access a node shell.
    - Run `lsblk` command to display disk partitions.
    - Only 2GB available in the `sdb` partition.

`Managed OS Disk Node Pool`
- **Configuration**:
  - **Disk Type**: Managed
  - **Temporary Disk Space**: 32GB
  - **OS Disk**: 30GB
  - **Partition Details**:
    - OS Disk: 30GB
    - Temporary Disk (`sdb`): 32GB
- **Purpose**:
  - Provides persistent storage for applications requiring data persistence.
- **Management**:
  - Stored in Azure storage account.
  - Ensures data persistence across VM relocations or host migrations.
- **Creation**:
  ```bash
  az aks nodepool add --name managed --cluster-name <aks-name> --resource-group <rg-name> -s Standard_B4ms --node-osdisk-type Managed --node-osdisk-size 30 --node-count 1
  ```
- **Observations**:
  - **Portal Configuration**: Disk size displayed as 30GB.
  - **CLI Verification**: 
    - Run `kubectl node-shell <node-name>` to access a node shell.
    - Run `lsblk` command to display disk partitions.
    - Full 32GB available in the `sdb` partition.

### Observations

- Both node pools utilize the same VM size and have a 30GB OS disk.
- Ephemeral OS disk node pool utilizes only 2GB of the temporary disk space, while managed OS disk node pool utilizes the full 32GB.
- The choice between ephemeral and managed disk depends on the nature of the workload and the need for data persistence.
- For short-term or stateless workloads, ephemeral OS disk may be suitable, while managed OS disk is preferred for applications requiring data persistence.


---
# 63. Default OS Disk Size
  - The operating system disk size is determined based on the number of vCPUs allocated to the VM.
  - If the disk size is not explicitly set, and ephemeral disks are not supported, the default size is applied.
  - The default size allocation is as follows:
    - 1-7 vCPUs: 128GB
    - 8-15 vCPUs: 128GB
    - 16-63 vCPUs: 128GB
    - 64+ vCPUs: 128GB
  - Other characteristics such as provisioned IOPS and throughput are resolved similarly based on the number of vCPUs.
- **Node Pool Configuration**:
  - Example : our Node pool VM size: standard_DS2_v2
  - This VM type is documented to have 2 vCPUs.
- **Verification**:
    - Run `kubectl get node` to retrieve node information.
    - Accessed a node shell with `kubectl node-shell <node-name>`.
    - Run `lscpu` command to display CPU information. , we see the number of CPUs to be 2.
   - **Azure Portal**:
    - Check the VM properties and confirm the VM size to be standard_DS2_v2.
    - Accessed the disk properties to check the disk size. and Observed the disk size to be 120GB.

---
# 63. NodePool Snapshots
https://learn.microsoft.com/en-us/azure/aks/node-pool-snapshot <br>
Node pool snapshots enable the creation of new node pools or clusters based on a configuration snapshot of existing node pools.
- Snapshot contains configuration information such as node image version, Kubernetes version, OS type, and OS.
- New node pools or clusters must use VMs from the same virtual machine family as the source snapshot.
- Snapshots can only be created and used in the same region as the source node pool
- **Usage**:
  - Create new node pools or clusters using the snapshot.
  - Upgrade Kubernetes version and node image based on the snapshot.
**Benefits:**
- Streamlined Deployment: Quickly replicate existing configurations for new deployments.
- Version Control: Maintain consistency across clusters by using snapshots as a reference point.
- Simplified Upgrades: Easily upgrade Kubernetes versions and node images based on predefined configurations.

**Node Pool Snapshot Creation:**

- **Create Snapshot**
     ```bash
     # obtain the node pool resource ID
     NODEPOOL_ID=$(az aks nodepool show --name <nodepool-name> --cluster-name <cluster-name> --resource-group <rg-name> --query id -o tsv)
     echo $NODEPOOL_ID
   
     # Utilize the obtained node pool ID to create a snapshot:
     az aks nodepool snapshot create --name <snapshot-name> --resource-group <rg-name> --nodepool-id $NODEPOOL_ID --location <region>
     ```
- **Create Node Pool from Snapshot:**
     ```bash
     # note the kubernetsversion and nodeimageVersion
     az aks nodepool snapshot show --name <snapshot-name> --resource-group <rg-name> --query id -o tsv

     # retreive the snapshot id from the snapshot created above
     SNAPSHOT_ID=$(az aks nodepool snapshot show --name <snapshot-name> --resource-group <rg-name> --query id -o tsv)
     echo $SNAPSHOT_ID

     # Use the obtained snapshot ID to create a new node pool based on the snapshot
     az aks nodepool add --name <new-nodepool-name> --cluster-name <cluster-name> --resource-group <rg-name> --snapshot-id $SNAPSHOT_ID --node-count 2 -s standard_DS3_v2
     ```
   **Note:**
   - When creating a new node pool from a snapshot, ensure that the chosen size belongs to the same virtual machine family as the original nodes.
   - In the above example the size of the existing nodes is "standard_ds2_v2". but we explicitly choose a size for the new node pool as "standard_ds3_v2" , w hichbelongs to the same family
   - Verify and compare the details of the new nodepool in the Azure portal.

---
# 64. Resize a NodePool
- Modifying VM plans or resizing instances at the VM level is not supported due to support policies.
- manual changes made to VM sizes do not persist after operations like reconcile or upgrade, resulting in recreation with the original size.
- Changing the size of a node pool directly is also not possible.

**`Workaround`**
  ```bash
  # Create a new node pool with the desired size, ensuring to maintain at least one system node pool in the cluster.
  az aks nodepool add --resource-group <ResourceGroup-name> --cluster-name <aks-cluster-name> --name <node-pool-name> --os-sku Mariner --node-count 1 -s Standard_B2ms --mode User

  # Cordon the nodes from the existing node pool to mark them as unschedulable.
  kubectl cordon <node-name>

  # Drain the nodes from the existing node pool to gracefully evict pods for rescheduling.
  kubectl drain <node-name> --ignore-daemonsets --delete-emptydir-data

  # Once all pods are running smoothly on the new node pool, delete the old node pool (np1).
  # Check pod status: `
  kubectl get pods -o wide

  #If all pods are scheduled on the new nodes, delete the old node pool from the portal.
  ```