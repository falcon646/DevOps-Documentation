## Storage Options in Azure Kubernetes Services (AKS)

In AKS, storage plays a crucial role in managing data for various workloads. Let's explore the storage options available and how they work within AKS:

#### 1. Azure Disk
- **Description**: Azure managed disks are block-level storage volumes managed by Azure and attached to Azure Virtual Machines (nodes) in AKS.
- **Ideal Use Case**: Suitable for data requiring high performance and low latency, such as databases or transaction logs.
- **Access**: Only accessible by a single node cuase they are mounted as read-write once.

#### 2. Azure Files
- **Description**: Provides fully managed file shares in the cloud using SMB, NFS, and Azure Files REST APIs.
- **Ideal Use Case**: Storage volumes accessible to multiple pods on different nodes simultaneously.
- **Access**: Utilizes SMB or NFS protocols; ensure port 445 (SMB) or ports 111 and 2048 (NFS) are open for connectivity.

#### 3. Azure Blob
- **Description**: Optimized for storing massive amounts of unstructured data, such as images, documents, or audio/video files.
- **Ideal Use Case**: Suitable for unstructured data like images, documents, or streaming data.
- **Access**: Can be mounted using NFS or BlobFuse; ensure ports 443 (BlobFuse) or ports 111 and 2048 (NFS) are allowed for connectivity.

#### Additional Options
- **NFS Server**: Manually create an NFS server and connect it to AKS.
- **Azure NetApp Files**: High-performance file storage service.
- **Azure Ultra Disks**: Provides high throughput and low latency for I/O-intensive workloads.

### Container Storage Interface (CSI)

In Azure Kubernetes Service (AKS), a CSI (Container Storage Interface) driver is a plugin that enables the dynamic provisioning of storage volumes for pods in the Kubernetes cluster. CSI drivers allow Kubernetes to work with different storage systems without needing to modify Kubernetes itself. Here's how CSI drivers work in AKS
AKS uses the Container Storage Interface (CSI) driver to manage Azure storage resources. CSI complies with the CSI specification and enables AKS to expose various file and block storage systems to Kubernetes workloads.

#### Features of CSI Drivers
- **Azure Disk**: Improved attach/detach performance, support for Premium SSD, snapshot volumes, clone, and resize operations.
- **Azure File**: Supports NFS version 4.1, integration with private endpoints, and parallel creation of file shares.

### Provisioning Options
- **Dynamic Provisioning**: Relies on storage classes to dynamically create storage resources based on workload requirements.
  - **Storage Classes**: Define various storage types and regulate storage usage for different workloads.
- **Static Provisioning**: Manually create Azure disks, files, or blobs and refer to them using Persistent Volumes (PVs) and Persistent Volume Claims (PVCs).
  - **PV and PVC**: Specify storage resources directly and attach them to pods, either inline or through PVCs.

By understanding the storage options and provisioning methods in AKS, administrators can effectively manage data storage for their Kubernetes workloads.


## Dynamically create Azure Disks PVs by using the built-in storage classes
[Documentation](https://learn.microsoft.com/en-us/azure/aks/azure-disk-csi#dynamically-create-azure-disks-pvs-by-using-the-built-in-storage-classes)

A storage class is used to define how a unit of storage is dynamically created with a persistent volume. For more information on Kubernetes storage classes, see Kubernetes storage classes.

When you use the Azure Disk CSI driver on AKS, there are two more built-in StorageClasses that use the Azure Disk CSI storage driver. The other CSI storage classes are created with the cluster alongside the in-tree default storage classes.

`managed-csi`: Uses Azure Standard SSD locally redundant storage (LRS) to create a managed disk.

`managed-csi-premium`: Uses Azure Premium LRS to create a managed disk.

The reclaim policy in both storage classes ensures that the underlying Azure Disks are deleted when the respective PV is deleted. The storage classes also configure the PVs to be expandable. You just need to edit the persistent volume claim (PVC) with the new size.


**Step 1 : Create a Cluster**
```bash
# create a simple aks cluster
az aks create -g aks-rg -n aks-azdisk-demo -c 2
```
Once the cluster is created , connect to the cluster

```bash
# list the storage classes
kubectl get storageclass

# output
F:\Workspace\DevOps>kubectl get sc
NAME                    PROVISIONER          RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE  
azurefile               file.csi.azure.com   Delete          Immediate              true                   2m41s
azurefile-csi           file.csi.azure.com   Delete          Immediate              true                   2m41s
azurefile-csi-premium   file.csi.azure.com   Delete          Immediate              true                   2m41s
azurefile-premium       file.csi.azure.com   Delete          Immediate              true                   2m41s
default (default)       disk.csi.azure.com   Delete          WaitForFirstConsumer   true                   2m41s
managed                 disk.csi.azure.com   Delete          WaitForFirstConsumer   true                   2m41s
managed-csi             disk.csi.azure.com   Delete          WaitForFirstConsumer   true                   2m41s
managed-csi-premium     disk.csi.azure.com   Delete          WaitForFirstConsumer   true                   2m41s
managed-premium         disk.csi.azure.com   Delete          WaitForFirstConsumer   true                   2m41s
```

The difference between the storage classes listed in the output of the above command lies primarily in the type of storage they offer and their characteristics:

`Azure File Storage Classes:`

- `azurefile:` Standard Azure File storage class.
- `azurefile-csi:` Azure File storage class using the Container Storage Interface (CSI).
- `azurefile-csi-premium:` Premium Azure File storage class using CSI.
- `azurefile-premium:` Premium Azure File storage class.

These storage classes are typically used for scenarios where you need to mount file shares to multiple pods simultaneously, such as for shared configuration files or application data.

`Azure Disk Storage Classes:`

- `default:` Standard Azure Disk storage class.
- `managed:` Managed Azure Disk storage class.
- `managed-csi`: Managed Azure Disk storage class using CSI.
- `managed-csi-premium:` Premium Managed Azure Disk storage class using CSI.
- `managed-premium:` Premium Managed Azure Disk storage class.

These storage classes provide block storage that can be mounted to a single pod, suitable for scenarios requiring persistent data storage for applications or databases.

- `Provisioner:` Indicates the plugin used to provision storage. For Azure File, it's `file.csi.azure.com`, while for Azure Disk, it's `disk.csi.azure.com`.

- `Reclaim Policy:` Specifies the reclaim policy for the volume. In our case, it's set to Delete, meaning the associated storage resources will be deleted when the PVC (PersistentVolumeClaim) is deleted.

- `Volume Binding Mode:` Defines how volumes are bound to PVs (PersistentVolumes). - `Immediate` means the volume will be provisioned as soon as the PVC is created
- `WaitForFirstConsumer` indicates that a PV is only bound once a Pod using the PVC is scheduled..

- `Allow Volume Expansion:` Indicates whether volume expansion is allowed or not.

- `CSI Integration:` Some storage classes use the Container Storage Interface (CSI) for provisioning and managing volumes, providing a more flexible and extensible approach.

- `Type of Storage:` Azure File storage is for file-based storage, while Azure Disk storage is for block-based storage. Premium variants offer higher performance and other features like encryption.


**Step 2 : Create a PVC and Pod using the managed-csi storage class**

We will use managed-csi for our example `kubectl get sc managed-csi`.
We can see here that the `Volume Binding Mode`is  WaitForFirstConsumer.
It means that it will create the disk after a pod requires to mount a volume.


```bash
# get details about the managed-csi storage class
kubectl get sc managed-csi -o yaml`

# output
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  creationTimestamp: "2024-03-12T04:38:54Z"
  labels:
    addonmanager.kubernetes.io/mode: EnsureExists
    kubernetes.io/cluster-service: "true"
  name: managed-csi
  resourceVersion: "341"
  uid: 9701b323-52c3-4c7c-927b-e70e3e3e549d
parameters:
  skuname: StandardSSD_LRS
provisioner: disk.csi.azure.com
reclaimPolicy: Delete
volumeBindingMode: WaitForFirstConsumer
```

- `parameters:` Specifies any parameters specific to the provisioner (the entity responsible for creating storage volumes). In this example, skuname: StandardSSD_LRS specifies the SKU (Service Level) name for the provisioned disks, indicating StandardSSD disks with Locally Redundant Storage (LRS).
- `provisioner:` Identifies the provisioner responsible for creating the storage volumes. Here, it's disk.csi.azure.com, indicating that the Azure Disk CSI (Container Storage Interface) driver is being used for provisioning.
- `reclaimPolicy:` Defines what action should be taken when a PersistentVolume associated with this StorageClass is no longer needed. In this case, it's set to Delete, meaning that the volume will be automatically deleted when it's no longer required.
- `volumeBindingMode:` Specifies how PersistentVolumes should be dynamically provisioned. Here, WaitForFirstConsumer means that the provisioning of a volume will be delayed until a Pod that requires the volume is scheduled. This mode ensures that volumes are only provisioned when they are actually needed by Pods, helping to conserve resources.


To use these storage classes, create a PVC and respective pod that references and uses them. A PVC is used to automatically provision storage based on a storage class. A PVC can use one of the pre-created storage classes or a user-defined storage class to create an Azure-managed disk for the desired SKU and size. When you create a pod definition, the PVC is specified to request the desired storage

- create a PVC
    ```yaml
    # pvc yaml
    apiVersion: v1
    kind: PersistentVolumeClaim
    metadata:
    name: pvc-azuredisk
    spec:
    accessModes:
        - ReadWriteOnce
    resources:
        requests:
        storage: 100Mi
    storageClassName: managed-csi
    ```
- create pod that uses the pvc
    ```yaml
    kind: Pod
    apiVersion: v1
    metadata:
    name: nginx-azuredisk
    spec:
    nodeSelector:
        kubernetes.io/os: linux
    containers:
        - image: mcr.microsoft.com/oss/nginx/nginx:1.17.3-alpine
        name: nginx-azuredisk
        command:
            - "/bin/sh"
            - "-c"
            - while true; do echo $(date) >> /mnt/azuredisk/outfile; sleep 1; done
        volumeMounts:
            - name: azuredisk01
            mountPath: "/mnt/azuredisk"
            readOnly: false
    volumes:
        - name: azuredisk01
        persistentVolumeClaim:
            claimName: pvc-azuredisk
    ```
Once the above resources are created , ispect the pv and pvc created

```bash
# kubectl get pv,pvc  
NAME                                                        CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                   STORAGECLASS   REASON   AGE
persistentvolume/pvc-06d7653a-d797-4ad3-8fd5-46734d1f048d   1Gi        RWO            Delete           Bound    default/pvc-azuredisk   managed-csi             35s

NAME                                  STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
persistentvolumeclaim/pvc-azuredisk   Bound    pvc-06d7653a-d797-4ad3-8fd5-46734d1f048d   1Gi        RWO            managed-csi    80s
```

**PersistentVolume (PV):**
1. **Name**: `pvc-06d7653a-d797-4ad3-8fd5-46734d1f048d` : This is the unique identifier for the PersistentVolume.
2. **Capacity**: `1Gi` : Indicates the storage capacity of the volume, which is 1 Gigabyte.
3. **access modes**: `RWO` (ReadWriteOnce) : Specifies the access modes for the volume. `RWO` means that it can be mounted as read-write by a single node.
4. **Reclaim Policy**: `Delete` : Represents the policy applied when the volume is released. `Delete` indicates that the volume will be deleted and its resources reclaimed.
5. **Status**: `Bound` : Indicates the current status of the volume. `Bound` means that it's successfully bound to a PersistentVolumeClaim and can be used by Pods.
6. **Claim**: `default/pvc-azuredisk` : Specifies the namespace (`default`) and name of the PersistentVolumeClaim that has bound to this volume (`pvc-azuredisk`).
7. **Storageclass**: `managed-csi` : Indicates the StorageClass associated with the PersistentVolume. It defines the provisioner and parameters for the volume.

**PersistentVolumeClaim (PVC):**
1. **Name**: `pvc-azuredisk` : The name of the PersistentVolumeClaim.
2. **Status**: `Bound` : Indicates that the claim has successfully bound to a PersistentVolume and can be used by Pods.
3. **Volume**: `pvc-06d7653a-d797-4ad3-8fd5-46734d1f048d` : Specifies the name of the PersistentVolume bound to this claim.
4. **Capacity**: `1Gi` : Indicates the storage capacity requested by the claim.
5. **Access Modes**: `RWO` (ReadWriteOnce) : Specifies the access modes requested by the claim.
6. **Storageclass**: `managed-csi` : Indicates the StorageClass associated with the claim. It defines the provisioner and parameters for the volume.

Once the pod gets into running state , lets inspect it

```bash
# view the capatity of the vlume mounted
kubectl exec -it <pod-name> -- df -h /mnt/azuredisk

# output
Filesystem                Size      Used Available Use% Mounted on
/dev/sdc                973.4M    292.0K    957.1M   0% /mnt/azuredisk
```

On th portal, under Infraresource group,  we can see the Azure disk. It shows that it is attached and whcih node it is managed by. Basically this is the node where our pod  using that pvc got scheduled.

```bash
# resize a pvc
kubectl patch pvc <pvc-name> -p '{"spec":{"resources":{"requests":{"storage":"<new-size>"}}}}'
```

## Volume snapshots
The Azure Disk CSI driver supports creating snapshots of persistent volumes. As part of this capability, the driver can perform either full or incremental snapshots depending on the value set in the incremental parameter (by default, it's true).

We ill create a volume snapshot of the pvc created above and then create a new pvc based on the snapshot

- **Step 1: Create a Volume Snapshot Class**

    A VolumeSnapshotClass in Kubernetes is a resource that defines the parameters for creating VolumeSnapshots, which are point-in-time copies of persistent volumes (PVs).
    ```yaml
    apiVersion: snapshot.storage.k8s.io/v1
    kind: VolumeSnapshotClass
    metadata:
      name: csi-azuredisk-vsc
    driver: disk.csi.azure.com
    deletionPolicy: Delete
    parameters:
      incremental: "true"  # available values: "true", "false" ("true" by default for Azure Public Cloud, and "false" by default for Azure Stack Cloud)
    ```

- **Step 2 : Create a volume snapshot**

    Now , create a volume snapshot from the PVC that we dynamically created before
    ```yaml
    apiVersion: snapshot.storage.k8s.io/v1
    kind: VolumeSnapshot
    metadata:
      name: azuredisk-volume-snapshot
    spec:
      volumeSnapshotClassName: csi-azuredisk-vsc
      source:
        persistentVolumeClaimName: pvc-azuredisk
    ```
- **Step 3: Create a new PVC based on a volume snapshot**
    
    We will now create the persistent volume claim which will have as a data source the volume snapshot that we just created.

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-azuredisk-snapshot-restored
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: managed-csi
  resources:
    requests:
      storage: 10Gi
  dataSource:
    name: azuredisk-volume-snapshot
    kind: VolumeSnapshot
    apiGroup: snapshot.storage.k8s.io
```

## Azure FileShare as a Kubernetes Volume

AKS provides facility using Azure File Shares as persistent volumes (PVs) in a Kubernetes cluster. Azure File Share is a fully managed file share service in Azure Storage, and Kubernetes allows you to mount Azure File Shares as volumes in your pods.

By using Azure File Share as a Kubernetes volume, you can easily share data between multiple pods running in your Kubernetes cluster. This is useful for scenarios such as sharing configuration files, logs, or other data across different parts of your application.

Azure File Share volumes are particularly well-suited for scenarios where you need shared access to files across multiple pods or where you need persistent storage that can be accessed from multiple locations.

Prerequisite :
Before you can use an Azure Files file share as a Kubernetes volume, you must create an Azure Storage account and the file share.

1. **Create Storage Account & Azure File Share**: the storage account should be created in the InfraRresourceGroup ok the aks cluster (an be in other rg as well)

```bash
# get the Infra REsourse Group name of the aks cluster
az aks show --resource-group <rg-name> --name <cluster-name> --query nodeResourceGroup -o tsv

# create storage account
az storage account create -n <storage-account-name> -g <infra-rg> -l <location> --sku Standard_LRS

# the connection string of the storage account
export AZURE_STORAGE_CONNECTION_STRING=$(az storage account show-connection-string -n <storageAccountName> -g <infra-rg> -o tsv)

# create file share using the connection string
az storage share create -n <shareName> --connection-string $AZURE_STORAGE_CONNECTION_STRING

# export the storage accountkey
STORAGE_KEY=$(az storage account keys list --resource-group <infra-rg> --account-name <StorageAccount-name> --query "[0].value" -o tsv)

# get the id of the fileshare
az storage share-rm show -g <infra-rg> --storage-account <storageaccount-name> --name <fileshare-name> -o tsv --query id 
```

2. **Configure Kubernetes Storage Class**: Configure a kubernetes secrets that contains credts to conect to the storage account
```bash
# create kubernetes secret
kubectl create secret generic <secret-name>--from-literal=azurestorageaccountname=<storage-account-name>--from-literal=azurestorageaccountkey=<storageaccount-key>
```

3. **Create PersistentVolume (PV) $ PersistentVolumeClaim (PVC)**:
```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  annotations:
    pv.kubernetes.io/provisioned-by: file.csi.azure.com
  name: <name>
spec:
  capacity:
    storage: 5Gi
  accessModes:
    - ReadWriteMany
  persistentVolumeReclaimPolicy: Retain
  storageClassName: azurefile-csi
  csi:
    driver: file.csi.azure.com
    volumeHandle: <id-of the-file-share> # make sure this volumeid is unique for every identical share in the cluster
    volumeAttributes:
      resourceGroup: <infra-rg> # optional, only set this when storage account is not in the same resource group as node
      shareName: <fileshare-name>
    nodeStageSecretRef:
      name: <secret-name>
      namespace: default
  mountOptions:
    - dir_mode=0777
    - file_mode=0777
    - uid=0
    - gid=0
    - mfsymlinks
    - cache=strict
    - nosharesock
    - nobrl
```
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: <name>
spec:
  accessModes:
    - ReadWriteMany
  storageClassName: azurefile-csi
  volumeName: azurefile
  resources:
    requests:
      storage: 5Gi
```

4. **Mount Azure File Share in Pods/Deployment**:
Update your container spec to reference your PersistentVolumeClaim and your pod in the YAML file
```yaml
volumeMounts:
- name : azurevolume
  mountPath: /path/to/mount
...
  volumes:
  - name: azurevolume
    persistentVolumeClaim:
      claimName: <pvc-name>
```

The Azure File Share folder will be mounted at the `/path/to/mount` inside the container. Now you can add files inside the file share and atached the volume to as many pods as you need. you'll be able to access the same files in every pod

 
## Creating Custom Storage Class with Private Endpoints

we'll create a custom storage class in AKS that dynamically provisions a private storage account with Geo redundant storage and a file share.

- when you inspect the storage acoount on the portal , we see that there is not private endpoint assiciated with the storage account(storage account -> networking -> private endpoint)
- when you inspet the endpoint (storage account -> endpoint) , you can fing the endpointof the file share here, named in the format `https://<storageaccount-name>.file.core.windows.net/`
- when you nslook up the above endpoint from one of the nodes in the k8 cluster , it will resolve to the private IP , that means the communaction b/w the aks cluster and the storage account is via public internet
- Now, we will create a storage account with private endpoint so that the communication does not flow via internet

#### Steps:
1. **Creating Custom Storage Class:s:**
   - We will use the configuration of `azurefile-csi` storage class and modify it for our custom storage class 
   - our sku will be `Standard_GRS`
   - we will have a addintional key value that specifies out endpoint should be private `networkEndpointType: privateEndpoint`
```yaml
allowVolumeExpansion: true
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  labels:
    addonmanager.kubernetes.io/mode: EnsureExists
    kubernetes.io/cluster-service: "true"
  name: azurefile-csi-private-grs
mountOptions:
- mfsymlinks
- actimeo=30
- nosharesock
parameters:
  skuName: Standard_GRS
  networkEndpointType: privateEndpoint
provisioner: file.csi.azure.com
reclaimPolicy: Delete
volumeBindingMode: Immediate
```

2. **Creating PVC using the Custom Storage Class:**
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: private-azurefile-pvc
spec:
  accessModes:
    - ReadWriteMany
  storageClassName: azurefile-csi-private-grs
  volumeName: azurefile
  resources:
    requests:
      storage: 5Gi
```
3. **Verifying Storage Account and Resources in the Infra Resource Group:**
   - Inspecting the Infra Resource Group , we see that the resources storage account , private dns zone , private endpoint and a network interface
   - the private endpoint can also be seen in the networking section of the storageaccount and also a A record in the private DNS zone for the private endpoint mapped to the networkinterface IP created alongside
   - when you nslookup from any node of the cluster , it will resolve to the network Interface IP 
   - if you nslook from your local machine ,it will resolve to the public ip only
   - you can also see the geo redundency details , under the datamanegement section and redundency balde


## Using StatefulSet with dynamically creating Azure Blob

We'll create two stateful sets in AKS that use Azure Blob and NFS premium storage classes. These stateful sets will automatically trigger the creation of persistent volume claims (PVCs) and provision the storage accounts required for the pods.

We will create StatefulSet that includes a volume claim template referencing the Azure Blob,
NFS premium and Azure BlobFuse premium storage classes that will automatically trigger the creation of PV and PVCs and the provisioning of the storage accounts, which will be of the block blob storage kind

- **StatefulSet** : 
  - A stateful set is a Kubernetes object that is used to manage stateful applications.
  - Unlike a deployment which is intended for stateless applications, a stateful set provides guarantees about the identity of the pods it manages, and it maintains a sticky identity across rescheduling.
  - This means that each pod in a stateful set has a unique identity and that identity is maintained across restarts and scaling events.
  - Stateful set are often used with stateful applications that require stable network identifiers, stable storage and ordered deployment and scaling. Dur to this, stateful sets are often associated with the one of persistent storage in Kubernetes.
  - Each pod in a stateful set can be configured to use a persistent volume claim to mount a unique volume that is associated with its identity. This allows stateful sets to provide stateful applications with reliable, durable and scalable storage that can survive pod restarts and rescheduling events.



#### Steps:
1. **Enabling Blob Driver:**
```bash
# while creating the cluster
az aks create --enable-blob-driver -n myAKSCluster -g myResourceGroup

# enable the driver on an existing cluster
az aks update --enable-blob-driver -n myAKSCluster -g myResourceGroup
```
2. **Creating Custom Storage Classes:**
   - when the blod csi driver is enabled,  new storage classes named `azureblob-fuse-premium` and `azureblob-nfs-premium` storage classes are added
   - It also adds , pods named 'csi-blob-node-xxx`
   - we prepare a stateful set YAML files, referencing the desired storage class (Azure Blob or NFS premium).
```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: statefulset-blob-nfs
  labels:
    app: nginx
spec:
  serviceName: statefulset-blob-nfs
  replicas: 1
  template:
    metadata:
      labels:
        app: nginx
    spec:
      nodeSelector:
        "kubernetes.io/os": linux
      containers:
        - name: statefulset-blob-nfs
          image: mcr.microsoft.com/oss/nginx/nginx:1.19.5
          volumeMounts:
            - name: persistent-storage
              mountPath: /mnt/blob
  updateStrategy:
    type: RollingUpdate
  selector:
    matchLabels:
      app: nginx
  volumeClaimTemplates:
    - metadata:
        name: persistent-storage
      spec:
        storageClassName: azureblob-nfs-premium
        accessModes: ["ReadWriteMany"]
        resources:
          requests:
            storage: 1Gi
```    
   - Apply the statefulset YAML files to create the statefulset and trigger the creation of PVCs.

3. **Verifying PVC Provisioning:**
   - Check the status of the PVCs to ensure they are successfully provisioned and bound to persistent volumes (PVs).

4. **Verifying Storage Account Creation:**
   - Navigate to the Azure portal and verify the creation of the storage accounts associated with the PVCs.
   - Confirm the properties and configurations of the storage accounts, including the kind of storage (block blob or nfs).

5. **Testing Connectivity and Scaling:**
   - Verify that pods are in running state and can access the provisioned storage accounts.
   - Test scaling by increasing the replicas of one stateful set and observe the creation of new pods and PVCs.
  







