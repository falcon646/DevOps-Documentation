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
