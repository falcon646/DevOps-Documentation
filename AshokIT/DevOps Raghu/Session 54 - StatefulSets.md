## Stateful Applications
Stateful applications are applications that store data and keep tracking it. All databases, such as MySQL, Oracle, and PostgreSQL, are examples of stateful applications. Stateless applications, on the other hand, do not keep the data. Node.js and Nginx are examples of stateless applications. For each request, the stateless application will receive new data and process it.

In a modern web application, the stateless application connects with stateful applications to serve the user’s request. A Node.js application is a stateless application that receives new data on each request from the user. This application is then connected with a stateful application, such as a MySQL database, to process the data. MySQL stores data and keeps updating the data based on the user’s request.

![image](https://github.com/falcon646/DevOps-Documentation/assets/35376307/338c6469-fb50-4770-ade4-f8007e30b50c)

## StatefulSets

A StatefulSet is the Kubernetes controller used to run the stateful application as containers (Pods) in the Kubernetes cluster. StatefulSets assign a sticky identity—an ordinal number starting from zero—to each Pod instead of assigning random IDs for each replica Pod. A new Pod is created by cloning the previous Pod’s data. If the previous Pod is in the pending state, then the new Pod will not be created. If you delete a Pod, it will delete the Pod in reverse order, not in random order. For example, if you had four replicas and you scaled down to three, it will delete the Pod numbered 3.

The diagram below shows how the Pod is numbered from zero and how Kubernetes persistent volume is attached to the Pod in the StatefulSets.
![image](https://github.com/falcon646/DevOps-Documentation/assets/35376307/8004cabf-a1f0-4e79-a1a6-2c9128ef3fb3)


StatefulSet is a higher-level abstraction that manages the deployment and scaling of a set of Pods with unique identities. StatefulSets are primarily used for stateful applications, where each instance (Pod) requires a stable and unique network identity and stable storage.

Here are some key characteristics and features of StatefulSets:

- Stable Hostnames:

  StatefulSets provide stable and unique network identities to each Pod. Each Pod gets a hostname based on its ordinal index within the set, making it easy to refer to individual instances.
  
- Stable Storage:

  StatefulSets support the use of Persistent Volumes (PVs) and Persistent Volume Claims (PVCs), ensuring that each Pod has its own unique and stable storage. This is crucial for stateful applications that require data persistence.

- Pod Ordering:

  Pods in a StatefulSet are created and scaled in a predictable order. The ordinal index assigned to each Pod in the set is used for ordering, and scaling operations maintain this order.

- Scaling:

  StatefulSets support both manual and automatic scaling. When scaling, new Pods are created with the next available ordinal index. Scaling down involves terminating Pods in reverse order.

- Updating:

  StatefulSets support rolling updates, allowing for controlled and orderly updates to the Pods. This is essential for applications that need to maintain consistency during updates.

- Headless Service:

  By default, StatefulSets create a Headless Service to manage the network identity of the Pods. This allows for DNS-based discovery of individual Pods.
- Operator Pattern:

  StatefulSets are part of the Operator pattern in Kubernetes, which aims to encode operational knowledge about specific applications into the Kubernetes API. This enables Kubernetes to manage applications more intelligently.

## When to Use StatefulSets
There are several reasons to consider using StatefulSets. Here are two examples:
- Assume you deployed a MySQL database in the Kubernetes cluster and scaled this to three replicas, and a frontend application wants to access the MySQL cluster to read and write data. The read request will be forwarded to three Pods. However, the write request will only be forwarded to the first (primary) Pod, and the data will be synced with the other Pods. You can achieve this by using StatefulSets.
- Deleting or scaling down a StatefulSet will not delete the volumes associated with the stateful application. This gives you your data safety. If you delete the MySQL Pod or if the MySQL Pod restarts, you can have access to the data in the same volume.

## Advantages of StatefulSets over Deployments

You can also create Pods (containers) using the Deployment object in the Kubernetes cluster. This allows you to easily replicate Pods and attach a storage volume to the Pods. The same thing can be done by using StatefulSets. What then is the advantage of using StatefulSets?

Well, the Pods created using the Deployment object are assigned random IDs. For example, you are creating a Pod named “my-app”, and you are scaling it to three replicas. The names of the Pods are created like this:

```yaml
my-app-123ab
my-app-098bd
my-app-890yt
```
After the name “my-app”, random IDs are added. If the Pod restarts or you scale it down, then again, the Kubernetes Deployment object will assign different random IDs for each Pod. After restarting, the names of all Pods appear like this:

```yaml
my-app-jk879
my-app-kl097
my-app-76hf7
```

All these Pods are associated with one load balancer service. So in a stateless application, changes in the Pod name are easily identified, and the service object easily handles the random IDs of Pods and distributes the load. This type of deployment is very suitable for stateless applications.

![image](https://github.com/falcon646/DevOps-Documentation/assets/35376307/12323b52-9afb-4c64-8e39-f7ba6c1a6a65)
Stateless application scaled for three replicas

However, stateful applications cannot be deployed like this. The stateful application needs a sticky identity for each Pod because replica Pods are not identical Pods.

Take a look at the MySQL database deployment. Assume you are creating Pods for the MySQL database using the Kubernetes Deployment object and scaling the Pods. If you are writing data on one MySQL Pod, do not replicate the same data on another MySQL Pod if the Pod is restarted. This is the first problem with the Kubernetes Deployment object for the stateful application.

![image](https://github.com/falcon646/DevOps-Documentation/assets/35376307/5f973f2a-bf85-4e6f-a451-2b0fa0480eef)
Stateful application Pod created with Deployment object

Stateful applications always need a sticky identity. While the Kubernetes Deployment object offers random IDs for each Pod, the Kubernetes StatefulSets controller offers an ordinal number for each Pod starting from zero, such as mysql-0, mysql-1, mysql-2, and so forth.

![image](https://github.com/falcon646/DevOps-Documentation/assets/35376307/05052356-af27-438f-aa1b-795809851cb7)
MySQL primary and replica architecture

For stateful applications with a StatefulSet controller, it is possible to set the first Pod as primary and other Pods as replicas—the first Pod will handle both read and write requests from the user, and other Pods always sync with the first Pod for data replication. If the Pod dies, a new Pod is created with the same name.

The diagram below shows a MySQL primary and replica architecture with persistent volume and data replication architecture.

![image](https://github.com/falcon646/DevOps-Documentation/assets/35376307/3fc856d1-c05b-46a4-b409-e24f741435eb)
MySQL primary and replica architecture with persistent volume

Now, add another Pod to that. The fourth Pod will only be created if the third Pod is up and running, and it will clone the data from the previous Pod.

![image](https://github.com/falcon646/DevOps-Documentation/assets/35376307/b62ba331-68c1-46be-8c97-1e33747270dc)
Add Pod to existing StatefulSets

In summary, StatefulSets provide the following advantages when compared to Deployment objects:

- Ordered numbers for each Pod
- The first Pod can be a primary, which makes it a good choice when creating a replicated database setup, which handles both reading and writing
- Other Pods act as replicas
- New Pods will only be created if the previous Pod is in running state and will clone the previous Pod’s data
- Deletion of Pods occurs in reverse order

## StatefulSet Pod Behaviour

Scaling operations (scaling up or down) and creating or deleting pods in a StatefulSet in Kubernetes have specific behaviors and considerations due to the stateful nature of the workloads. Let's explore different scenarios:

- Scaling Up:
  - Pod Creation: When you scale up a StatefulSet by increasing the number of replicas, new pods are created with the next available ordinal index. For example, if you have Pods web-0 and web-1 and you scale up, a new pod with the name web-2 will be created.
  - Volume Provisioning: Each pod in a StatefulSet typically has its own Persistent Volume Claim (PVC), ensuring that each pod has its own stable storage. When scaling up, new PVCs are provisioned for the new pods.

- Scaling Down:
    - Pod Termination: When scaling down a StatefulSet, pods are terminated in reverse ordinal order. For example, if you have Pods web-0, web-1, and web-2, and you scale down, web-2 will be terminated first.
    - Volume Retention: Pods are terminated gracefully, allowing them to complete their work and release resources. The associated Persistent Volume (PV) and Persistent Volume Claim (PVC) are not immediately deleted. This helps preserve data. PV and PVC deletion can be configured based on the reclaim policy.

- Pod Deletion:
    - Pod Deletion: Deleting a pod triggers the StatefulSet to create a replacement pod with the same ordinal index. The new pod is created with a new unique identity but retains the same stable storage.
  
    - Volume Retention: Similar to scaling down, when a pod is deleted, the associated PV and PVC are not immediately deleted. This helps in preserving data and allows the new pod to reuse the existing volume.

- Pod Creation:
    - Unique Identity: Each pod in a StatefulSet has a unique identity based on its ordinal index. When creating a new pod, it is assigned the next available ordinal index, and a corresponding PV and PVC are provisioned.
    - Stable Storage: The use of PVs and PVCs ensures that each pod gets its own stable storage. Even if a pod is deleted and a new one is created, the storage is retained, allowing for data persistence.
  
Considerations:
- Pod Identity: The ordinal index and stable network identity are crucial for stateful applications. The StatefulSet ensures that each pod has a predictable and unique identity.
- Stateful Application Awareness: Applications running in StatefulSets need to be aware of their state and handle any data synchronization or recovery processes during scaling operations.
- Persistent Volumes: Proper configuration of Persistent Volumes is essential to ensure that data is retained and made available to new pods.
- Storage Reclaim Policy: The storage reclaim policy in the PVC specifies whether the associated PV should be retained, deleted, or recycled when the PVC is deleted. This policy influences the behavior of scaling and pod deletion.
- Init Containers: Init containers can be used in StatefulSets to perform initialization tasks before the main container starts, which can be beneficial for stateful applications.

### Headless Service 

A Headless Service in Kubernetes is a service that does not have a cluster IP assigned. It is also known as a service with a "None" cluster IP. Unlike a typical Service, a Headless Service does not load balance traffic among pods. Instead, it allows for DNS-based pod discovery.
- `Pod Discovery` : When a StatefulSet is associated with a Headless Service, each pod in the StatefulSet gets a DNS record created. The DNS record is based on the combination of the pod name, the StatefulSet name, and the Headless Service name. For example, if the serviceName is set to "example-headless-svc," and the StatefulSet name is "example-statefulset," the DNS records for the pods might look like example-statefulset-0.example-headless-svc, example-statefulset-1.example-headless-svc, and so on.
- **Use Case** : The use of a Headless Service is particularly valuable for stateful applications where each pod has a unique identity and where stable network identities are crucial. DNS-based pod discovery allows other applications or services within the cluster to locate and communicate with individual pods directly.


### Structure of a StatefulSet Yaml

The StatefullSet yaml are almost simmilar to the Deployment yaml except a few changes mentioened below
- Stable Storage: : StatefulSets include a volumeClaimTemplates section for defining Persistent Volume Claims (PVCs) associated with each pod. This ensures stable and unique storage for each pod.(Deployments typically do not include volume claim templates unless persistent storage is explicitly required)
- Service Naming: StatefulSets often have a Headless Service associated with them, which is used for DNS-based pod discovery. The serviceName field in the StatefulSet specifies the name of this service. (Deployments do not inherently require a Headless Service for pod discovery.)
```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: ...
spec:
  replicas: ...
  serviceName: "example-headless-svc"
  selector: ...
  template: ...
  volumeClaimTemplates:
  - metadata:
      name: data
    spec:
      accessModes: [ "ReadWriteOnce" ]
      resources:
        requests:
          storage: 1Gi
```
- `serviceName` : This field specifies the name of the Headless Service that will be created or associated with the StatefulSet
-  `The volumeClaimTemplates` section in a StatefulSet YAML defines a template for creating Persistent Volume Claims (PVCs) associated with the pods created by the StatefulSet
- `volumeClaimTemplates` : This is an array that allows you to define multiple templates for creating PVCs. In this example, there is a single template defined.
- `metadata`: The metadata section contains information about the PVC template, such as its name. In this case, the PVC will be named "data."
- `spec` : The spec section defines the specification of the PVC template.
- `accessModes` : This field specifies the access modes for the PVC. In this example, the access mode is set to ReadWriteOnce, indicating that the volume can be mounted as read-write by a single node.
- `resources` : The resources field specifies the resource requirements for the PVC. In this case, the PVC is requesting a storage size of 1 gigabyte (1Gi).
