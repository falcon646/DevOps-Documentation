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
