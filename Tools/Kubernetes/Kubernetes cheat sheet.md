```bash
# To find the current API version of a resource in Kubernetes
kubectl api-resources
# example : current apiversion for pod
kubectl api-resources | grep Pod

# details about a respouce
kubectl explain <resource-name>

# details about the API version of a specific resource
kubectl explain <resource-name> --api-version=<desired-api-version>
kubectl explain pod --api-version=v1

# view logs from all pods under a deployment by selecting the label
kubectl logs -l <label-selector> --all-containers=true


# to explain a parameter of any yaml
kubectl explain [RESOURCE] [OPTIONS]

# get information about the Pod resource
kubectl explain pod

# to get information about specific fields within a resource
kubectl explain pod.spec.containers
kubectl explain pod.metadata.annotations
kubectl explain pod.metadata.labels
kubectl explain pod.spec.containers.command

# view the the current user can perform a action
kubectl auth can-i <action> <resource> -n <namespace>
kubectl auth can-i get pods
kubectl auth can-i create pods
kubectl auth can-i delete pods


# resize pvc
kubectl patch pvc <pvc-name> -p '{"spec":{"resources":{"requests":{"storage":"<new-size>"}}}}'

```
### Common apiVersions
```yaml
# Pods
apiVersion: v1

# Services
apiVersion: v1

# ReplicaSets
apiVersion: apps/v1

# Deployments
apiVersion: apps/v1

# ConfigMaps
apiVersion: v1

# Secrets
apiVersion: v1

# Persistent Volumes
apiVersion: v1

# Persistent Volume Claims
apiVersion: v1

# Horizontal Pod Autoscaler (HPA)
apiVersion: autoscaling/v1

# StatefulSets
apiVersion: apps/v1

# DaemonSets
apiVersion: apps/v1

# Services (Network Policies)
apiVersion: networking.k8s.io/v1

# Ingress Controllers
apiVersion: networking.k8s.io/v1

# Jobs
apiVersion: batch/v1

# CronJobs
apiVersion: batch/v1beta1

# Storage Classes
apiVersion: storage.k8s.io/v1

# Pod Disruption Budgets
apiVersion: policy/v1beta1

# Custom Resource Definitions (CRDs)
apiVersion: apiextensions.k8s.io/v1
```

### Generate Yaml templates
You can generate YAML templates for different Kubernetes resources using the `kubectl create` command with the `--dry-run=client` flag. This flag instructs `kubectl` to simulate the resource creation without actually sending the request to the Kubernetes cluster, and instead, it prints the generated YAML to the standard output. Here's how you can do it for various resources:
```bash
# Pod
kubectl create deployment my-pod --image=nginx --dry-run=client -o yaml

### Service:
kubectl create service clusterip my-service --tcp=80:80 --dry-run=client -o yaml

### Deployment:
kubectl create deployment my-deployment --image=nginx --dry-run=client -o yaml

### ConfigMap:
kubectl create configmap my-configmap --from-literal=key1=value1 --from-literal=key2=value2 --dry-run=client -o yaml

### Secret:
kubectl create secret generic my-secret --from-literal=secret1=value1 --from-literal=secret2=value2 --dry-run=client -o yaml

### PersistentVolume:
kubectl create pv my-pv --capacity=1Gi --access-mode=ReadWriteOnce --host-path=/path/to/storage --dry-run=client -o yaml

### PersistentVolumeClaim:
kubectl create pvc my-pvc --resources=requests.storage=1Gi --access-mode=ReadWriteOnce --dry-run=client -o yaml

### capture the output and redirect it to a file if you want to save it to a YAML file.
kubectl create deployment my-deployment --image=nginx --dry-run=client -o yaml > my-deployment.yaml

# servive
kubectl expose deploy <deploy-name> --port <port-num> --type <svc-type> --dry-run=client -o yaml > svc.yaml
```
