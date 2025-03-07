## Kubernetes Objects

In Kubernetes, objects are entities used to define and manage the state of the cluster. 
They represent various components and resources within the cluster, such as applications, services, storage, and networking. 
Kubernetes objects are defined using YAML or JSON configuration files and can be created, updated, or deleted using the Kubernetes API. 

1.	Pod: The basic building block of Kubernetes. A pod represents a single instance of a running process within the cluster. It can encapsulate one or more containers that share the same network and storage resources.

2.	ReplicaSet: It ensures a specified number of pod replicas are running at all times. It is responsible for maintaining the desired replica count of a pod template in the cluster. If the actual number of replicas falls below the desired count, the ReplicaSet creates additional pods to match the desired count.

3.	Deployment: A higher-level abstraction that manages and updates a set of replica pods. Deployments provide declarative updates, rolling updates, and rollback capabilities for application deployments.

4.	Service: A service provides a stable network endpoint for accessing a group of pods. It enables load balancing and automatic service discovery within the cluster, allowing other applications to interact with the pods without needing to know their individual IP addresses.

5.	Namespace: Namespaces are used to logically divide a cluster into virtual clusters. They provide a way to organize and isolate resources, allowing different teams or applications to have their own isolated environment within the cluster.

6.	ConfigMap: A ConfigMap stores configuration data as key-value pairs. It allows you to separate configuration from application code and provides a centralized way to manage and update configuration settings.

7.	Secret: Secrets are used to store sensitive information such as passwords, API keys, and TLS certificates. They provide a secure way to distribute and manage sensitive data within the cluster.

8.	Volume: A volume provides a way to store and access data in a pod. It enables containers within a pod to share and persist data independently of the pod's lifecycle.

9.	StatefulSet: StatefulSets manage stateful applications that require stable network identities and persistent storage. They ensure that pods are created in a predictable order and provide stable network identities and persistent storage volumes.

10.	DaemonSet: A DaemonSet ensures that a pod runs on every node in the cluster. It is useful for deploying system daemons, log collectors, and other utilities that need to run on every node.

11.	Job: Jobs manage batch or single-run tasks. They create one or more pods to run the task and ensure that the specified number of successful completions is achieved.


## Strcuture of a Kubernetes Yaml file

A Kuberntes yaml file has 2 importnant sections

- API Version and Kind: 
    - Every Kubernetes object has an API version and a kind. These fields specify the version of the Kubernetes API and the type of resource being defined.
- Metadata: Metadata includes information like the name, namespace, labels, and annotations for the resource.
- Spec:
The spec section defines the desired state of the resource. The structure of the spec section varies depending on the resource type.
```yaml
apiVersion: <api-version>
kind: <resource-kind>
metadata:
  name: <resource-name>
  namespace: <namespace>
  labels:
    key1: value1
    key2: value2
  annotations:
    key1: value1
    key2: value2
spec:
  key1: value1
  key2: value2
```

### Pods:
In Kubernetes, a pod is the smallest and simplest unit of deployment. 
It represents a single instance of a running process within a cluster.
Pods are used to encapsulate one or more containers, along with shared resources and configuration that are co-located and share the same context.
- Container encapsulation: Pods provide a way to encapsulate and manage one or more containers together as a single unit. Containers within a pod share the same network namespace, IP address, and ports. They can communicate with each other using localhost.
- Atomic scheduling: Pods are the basic unit of scheduling in Kubernetes. When scheduling pods, Kubernetes ensures that all containers within a pod are scheduled on the same node. This helps ensure that containers in the same pod have low-latency communication and can share resources efficiently.
- Shared resources: Pods share certain resources, such as storage volumes and IP addresses. Each pod has its own unique IP address within the cluster, enabling direct communication between pods using IP-based protocols.
- Lifecycle coordination: Pods provide a way to coordinate the lifecycle of multiple containers. When a pod is created, all containers within the pod are started simultaneously. Similarly, when a pod is deleted, all containers within the pod are terminated together.
- Single service endpoint: Pods are not directly exposed outside the cluster. Instead, they are typically used as building blocks for higher-level abstractions like services and deployments. Services provide a stable endpoint to access pods, allowing external traffic to be load-balanced across multiple pod instances.
- Scalability and resilience: Pods can be horizontally scaled by creating multiple replicas of the same pod template. Kubernetes handles the distribution of replicas across nodes and ensures load balancing. If a pod fails, Kubernetes can automatically reschedule and recreate the pod to maintain the desired replica count.
- Metadata and labels: Pods can be labelled and annotated with metadata, allowing for easy grouping, selection, and management. Labels are key-value pairs attached to pods, enabling flexible pod selection for operations like scaling, deployment, and networking.

Sample pod.yaml
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-test-pod
spec:
  containers: # containers becuase it can have a list of container
  # mention multiple container as a list of objects
    - name: my-web-app
      image: javabyraghu/maven-web-app
      ports: # ports because we have to mention multipleports
        - containerPort: 8080 # is the port where the application inside this container listens to
```
- to create a pod from this yaml file will use the comand `kubectl create -f pod.yaml`

### Commands to create resources
```bash
# generate a kubernetes resource using yaml file
kubectl create -f nginx-pod.yml
# To delete configure resource created from YAML
kubectl delete -f nginx-pod.yml
# to update an already existing reourse with its yaml file
kubectl apply -f nginx-pod.yml

# If the resource specified in the YAML file already exists, kubectl create will return an error
# If the resource specified in the YAML file already exists, kubectl apply will update the resource according to the changes made in the YAML file
# `kubectl apply`` is more declarative and is suitable for a workflow where you have a YAML file that represents the desired state, and you want Kubernetes to manage the state.
# It allows you to perform rolling updates and apply changes to running resources without needing to delete and recreate them.
```
### commands to comminucatie with pods
```bash
# Create a pod on the fly
kubectl run <pod-name> --image=<image-name> --port=<container-port>
kubectl run my-pod --image=nginx --port=80

# list all the pods 
kubectl get pods # in deafult namespace
kubectl get pods -A # in all namespace
kubectl get pods -n kube-system # in specific namespace

# Format the output in different forms
kubectl get pods <pod-name> 
kubectl get pods <pod-name> -o wide
kubectl get pods <pod-name>  -o yaml
kubectl get pods <pod-name>  -o json

# View Pod details
kubectl describe pod <pod-name>
# view pod logs
kubectl logs <pod-name>

# execute commands inside pod
kubectl exec <pod-name> -- <command>
kubectl exec my-pod -- cat /etc/os-release
kubectl exec my-pod – ls /etc/
kubectl exec my-pod -- echo $SHELL

# acess the shell inside the pod
kubectl exec -it <pod-name> -- /bin/bash
kubectl exec -it <pod-name> -- bash
kubectl exec -it <pod-name> -- sh

# see the labels automatically generated for each Pod
kubectl get pods --show-labels

# to link with HOST PORT
kubectl port-forward <pod-name> <local-port>:<pod-port>
kubectl port-forward my-pod 8080:80 --address 0.0.0.0 & # map the runing pod port to port 8080 of the system so that you can access this app using ip:port of the host machine
# Here 0.0.0.0. Indicates access from anywhere (internet location) & means run in background

    # use below commands to stop Nginx Service rinning on port 8080 from the above command
    ps –aux | grep ‘8080’
    kill <process-id>

# Get Pod IP Address
kubectl get pod <pod-name> -o wide
kubectl get pod <pod-name> -o jsonpath='{.status.podIP}'

# delete a pod
kubectl delete pod <pod-name>
```

### Sample nginx pod yaml
```yaml
apiVersion: v1
kind: Pod
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