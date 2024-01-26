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
