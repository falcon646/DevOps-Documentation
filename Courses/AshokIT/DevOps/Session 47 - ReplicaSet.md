## ReplicaSet
ReplicaSet is a resource object used to ensure that a specified number of identical Pods are running at all times. It is part of the Kubernetes Replication Controller family and provides a higher-level abstraction for managing and scaling sets of Pods.

- Pod Replication: ReplicaSets define the desired number of Pod replicas that should be running. If the actual number of Pods deviates from the desired state, the ReplicaSet takes action to reconcile the difference by either creating new Pods or terminating existing ones.
- Selector-based Matching: ReplicaSets use a selector to identify the Pods it manages. The selector uses labels to match Pods based on their metadata, allowing the ReplicaSet to control and manage a set of Pods with specific labels.
- Automatic Scaling: ReplicaSets support automatic scaling. You can scale the number of replicas up or down to handle changes in demand by modifying the ReplicaSet's replica count.
- Pod Template: ReplicaSets use a Pod template to create new Pods or replace terminated ones. The template specifies the container image, resource requirements, labels, and other configuration options for the Pods.
- Immutable Updates: ReplicaSets treat updates to the Pod template as immutable. To update a ReplicaSet, you typically create a new ReplicaSet with the updated template, and Kubernetes handles the process of scaling up the new ReplicaSet and scaling down the old one.
- Owner-Reference: ReplicaSets are the owner of the Pods they manage. They set themselves as the owner of the Pods using an owner reference, which helps maintain the relationship between the ReplicaSet and its managed Pods.

ReplicaSets are typically used for stateless applications where individual Pods are interchangeable. They provide high availability and fault tolerance by ensuring that the desired number of Pods are always running, even in the face of failures or node disruptions.

Note: It is not recommended to use ReplicaSet, instead use a more powerful and flexible resource called as Deployment. Deployments provide declarative updates, rolling updates, and rollback capabilities on top of ReplicaSets.

Unlike pods, we cannot create ReplicaSet using command without YAML file. We need to define one YAML File and then execute as create/apply command.

- when you create a replicaset , it internally creates pod wnad manages them
- we need to pass the pod template to a replicaset for it to manage 
- what is a pod template ?
    - a pod template is the pod yaml wich only contains the metadata and spec directives and not the apiversion or the kind
    . example
    ```yaml
    metadata:
      name: my-pod
      labels:
        app: my-web-app
	    type: backend
    spec:
      containers:
        - name: nginx-container
          image: nginx
          ports:
            - containerPort: 80
    ```
- the replicaset yaml also contains how
 many replicas you want and selector section which identifies which pods needs to be managed by the replicaset
- The template field is used to define the specification for creating new Pods when the ReplicaSet needs to scale up or during a rolling update
- The selector field is used to identify the set of existing Pods in the cluster that the ReplicaSet should manage and maintain the desired number of replicas for.

### Basic structure of RepliaSet
```yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata: 
  name: 
spec:
  replicas:  # mention no of replicas
  selector:  # to identify pods that needs to be managed by this rs
  template:  # the pod template
```
### Sample ReplicaSet
```yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata: 
  name: my-test-rs
spec:
  replicas: 3
  selector:
    matchLabels: # should be same as the lables in pod template
      labels:
        app: my-web-app
	    type: backend
  template:
    metadata:
      name: my-pod
      labels:
        app: my-web-app
	    type: backend
    spec:
      containers:
        - name: nginx-container
          image: nginx
          ports:
            - containerPort: 80
```
## commands
```bash
# create ReplicaSet from yaml
kubectl create -f rs-test.yml

# modify exististing yamla and apply
kubectl apply -f rs-test.yml

# completely Modify Pod Template
kubectl replace –f rs-test.yml

# list ReplicaSets 
kubectl get replicasets
kubectl get rs
kubectl get rs –o wide
kubectl get rs <replica-set-name> –o json
kubectl get rs <replica-set-name> –o yaml

# describe ReplicaSet 
kubectl describe rs <replica-set-name>

# edit the replicaset directly
kubectl edit rs <replica-set-name>


# temporaryly update the no of replicas through command directly
$ kubectl scale replicaset <replicaset-name> --replicas=<desired-replica-count>

# Delete ReplicaSet
$ kubectl delete rs <replica-set-name>
$ kubectl delete -f rs-test.yml
```