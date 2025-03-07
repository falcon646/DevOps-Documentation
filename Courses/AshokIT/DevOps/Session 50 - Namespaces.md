# Namespace (ns)

Namespace is a virtual cluster or logical partition within a cluster that provides a way to organize and isolate resources. It allows multiple teams or projects to share the same physical cluster while maintaining resource separation and access control.

1.	Resource Organization: Namespaces provide a way to organize and categorize resources such as pods, services, deployments, and more. It helps to logically group related resources and provides better manageability.

2.	Resource Isolation: Namespaces provide resource isolation by creating separate virtual clusters within a physical cluster. Resources within a namespace are scoped to that namespace and cannot directly interact with resources in other namespaces.

3.	Resource Quotas: Namespaces can have resource quotas defined to limit the amount of compute resources (CPU, memory) that can be consumed by the resources within the namespace. This ensures that one namespace cannot monopolize all available resources in the cluster.


### Creating Namespaces:

Namespaces ca be cretaed using 2 ways

- Using kubectl :`kubectl create namespace <namespace-name>`
- Using Yaml file

    ```yaml
    apiVersion: v1
    kind: Namespace
    metadata:
    name: <namespace-name>
    ```
    - apply the yaml file: `kubectl apply -f ns.yml`

### Binding Resources to a Namespace

To bind any reources to a namespace ,  specify the value for the key `namespace` under `metadata`` tag

- if you do not specify the namespaces in the yaml file for creating a resource  , the resource gets created in the default namespace

- example

```yaml
apiVersion: ...
kind: ...
metadata:
  namespace: com-att-idp
spec:
  ...
```

- Example Pod with Namespace
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
  namespace: com-att-idp
spec:
  containers:
  - name: my-container
    image: nginx:1.23
```
- if you do not add the namespaces in the yaml file , you can still bind it to a namespaces while creating it by adding the option `-n <namespace-name>` to the create/apply command

`kubectl create -f test.yaml -n <namsepace-name>` <br>
`kubectl create -f test.yaml -n <namsepace-name>`

### Namespace commands
- the default namespaces is named `default`
- while using kubectl , if you do not specifiy the namespaces explicitly , then it retrievs the data only from the default namespaces
- deleting a namespace will delete all the resources under it

```bash
# To create a namespace:
kubectl create namespace <namespace-name>
kubectl create ns my-bank

# To switch to a specific namespace: (make this as default type)
$ kubectl config set-context --current --namespace=<namespace-name>

# To list all namespaces:
kubectl get namespaces

# To get resources within a specific namespace:
kubectl get <resource-type> -n <namespace-name>
kubectl get pods -n my-bank
kubectl get deploy -n my-bank
kubectl get deploy --namespace my-bank
kubectl get all --namespace my-bank
kubectl get deploy -n my-bank

# get resources from all namespaces
kubectl get <resource-type> -n A
kubectl get deploy -n A
kubectl get deploy --namespace A
kubectl get all --namespace A
kubectl get deploy -n A

# To delete a namespace and all associated resources:
kubectl delete namespace <namespace-name>
kubectl delete ns my-bank

# bind a new resource to a namespaces while using create/apply
kubectl create -f test.yaml -n <namsepace-name>
kubectl create -f test.yaml -n <namsepace-name>

# command to create a new resource under a given namespace
kubectl create deployment my-dep --image=busybox --namespace my-bank
```


