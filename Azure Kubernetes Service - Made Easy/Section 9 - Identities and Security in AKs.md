
To access Azure resources like Load Balancer and manage disks and Azure Kubernetes cluster needs an identity. This identity may be a service principal or a managed identity.

### Managed Identity
- Managed identity is the default identity in AKS. 
- If you don't specify that you want service principal, then managed identity will be used. 
- With the help of a managed identity feature in Azure, resources can authenticate to other Azure resources without the user having to deal with managing the authentication credentials.
- This is a special type of service principal that provides automatic credential rotation, so you don't have to worry about expired credentials.
- Azure provides two types of managed identities.
	- `System assigned` : which are tied to the life cycle of an Azure resource and can be associated with a single Azure resource. If we delete the resource that the system assigned identity is tied to, the system assigned identity will also get deleted.
	- `user assigned` : This is a standalone Azure resource with own life cycle that can be associated with multiple Azure resources. If we delete the resource that the user assigned identity is tied to, the user assigned identity will not get deleted.
- In AKS, to manage cluster resources like load balancer, managed public IP and others, an identity is used
- When you create an AKs cluster, unless you bring a user assigned managed identity, a control plane system assigned managed identity gets automatically created and this is managed by the Azure platform.
- You can bring your own identities for control plane and for Kubelet as well. If you don't bring your own identity, The managed identity in the Infrastructure Resource Group is a user assigned managed identity.
- Its goal is to authenticate the AKs cluster with the Azure Container Registry or ECR. This is also called Kubelet identity.
- Other managed identities may get created for specific add ons that you enable during cluster creation or later, like Azure Monitor.

### Service principal
- A service principle in Azure is a security identity that is used to authenticate and authorize access to Azure resources. 
- It is essentially an identity that represents an application service or other resource that needs to access Azure resources. 
- When you create a service principle, Azure generates a unique identity that can be used to authenticate with Azure services and resources. You can then grant permission to the service principle to access specific resources.
- A general format for a service principalis formed from a client ID and a secret or password.
- The secret of a service principle is by default valid for one year, and then you need to rotate it and update it at AKS level, otherwise the cluster will be degraded and not able to provision the resources, get upgraded and so on.
- The service principle credentials are kept on the agent node VM in the file /etc/kubernetes/azure.json and not in the Kubernetes cluster

### Service Principal
A service principal in Azure Active Directory (Azure AD) is a security identity used by applications, services, and automation tools to access Azure resources. It provides a way to authenticate and authorize access to Azure resources without needing to use a user's credentials directly.

Here are some key points about service principals:

1. **Identity**: A service principal is a non-human identity used for programmatic access to Azure resources. It can represent applications, services, or automated processes.

2. **Authentication**: Service principals can authenticate using either a client secret, a certificate, or managed identity. A client secret is a password-like credential, while a certificate provides a more secure method of authentication.

3. **Authorization**: Service principals are granted permissions (roles) in Azure RBAC (Role-Based Access Control) to access specific Azure resources. These permissions can be scoped at various levels, such as subscription, resource group, or individual resource.

4. **Usage**: Service principals are commonly used by applications running in Azure, such as virtual machines, Azure services, or Kubernetes clusters (including AKS). They are also widely used by automation scripts, CI/CD pipelines, and other tools that need to interact with Azure resources programmatically.

5. **Lifecycle**: Service principals have their own lifecycle independent of user accounts. They can be created, assigned permissions, and deleted programmatically. It's important to manage the lifecycle of service principals securely, ensuring they are removed when no longer needed to reduce the risk of unauthorized access.

In the context of AKS (Azure Kubernetes Service), service principals are commonly used to authenticate and authorize the Kubernetes cluster to access other Azure resources, such as Azure Container Registry (ACR), Azure Key Vault, or Azure Storage. They are also used for communication between the AKS control plane and the underlying Azure infrastructure.


## Creating AKS Cluster with Service Principal Identity

1. **Creating Service Principal:**
   - Used the `az ad sp create-for-rbac` command to create a service principal for AKS with RBAC enabled.
   - Copy the values for appId and password from the output. You use these when creating an AKS cluster
```bash
# create service principle
az ad sp create-for-rbac --skip-assignment --name <sp-name>

# output 
{
  "appId": "559513bd-0c19-4c1a-87cd-851a26afd5fc",
  "displayName": "myAKSClusterServicePrincipal",
  "name": "http://myAKSClusterServicePrincipal",
  "password": "e763725a-5eee-40e8-a466-dc88d980f415",
  "tenant": "72f988bf-86f1-41af-91ab-2d7cd011db48"
}
```

2. **Creating AKS Cluster:**
   - Used the `az aks create` command to create the AKS cluster.
   - Specify the service principal's appID (client ID) and client secret in the command parameters.
```bash
# create aks cluster with the service pricipal
az aks create --resource-group myResourceGroup --name myAKSCluster --service-principal <appId> --client-secret <password>
```

3. **Verifying Service Principal:**
   - Check the creatin of the service principal in the Azure portal under "App registrations.". Go to certificates and secrets , we cannot see the secret value 
   - Check the expiration date of the service principal's client secret.

4. **Exploring Cluster Configuration:**
   - Access the shell of any node if the cluster using node-shell and then `cat /etc/kubernetes/azure.json` file to view the service principal's client ID and password (client secret). If the aks cluster had a managed identity , these values would have been `msi`

## Certificates in Kubernetes

In Azure Kubernetes Service (AKS), certificates play a crucial role in establishing secure communication between various components of the cluster and authenticating access to the Kubernetes API server. Here are some key points about certificates in an Azure Kubernetes cluster:

- Certificates are essential for secure communication and authentication within a Kubernetes cluster.
- They are typically issued by a Certificate Authority (CA) responsible for verifying entity identities and signing certificates.

- **Cluster CA Certificate**: AKS has a Cluster CA (Certificate Authority) certificate. This certificate is used to sign other certificates within the cluster and is responsible for verifying the identity of components and users.
	- The AKS API server creates a Certificate Authority called as the `Cluster CA`
	- Cluster CA certificates expire after 30 years, providing long-term security for the cluster.
- **Certificate Rotation**: AKS supports certificate rotation to ensure security and prevent the expiry of certificates. AKS can automatically rotate certificates, including the Cluster CA certificate, to maintain security within the cluster.
   - AKS automatically rotates Cluster CA certificates by default for clusters with RBAC enabled.
   - Manual certificate rotation can also be initiated using the `az aks rotate-certs -g <rg-name> -n <cluster-name>` command, specifying the resource group and cluster name.
   - Certificate rotation typically takes around 30 minutes to complete.

- **API Server Certificate**: The API server certificate is used to authenticate and encrypt communication between clients (such as `kubectl` or applications) and the Kubernetes API server. It ensures that the communication remains secure and tamper-proof.

- **Kubelet Server Certificate**: Each node in an AKS cluster runs a kubelet process responsible for managing containers. The kubelet server certificate is used by the kubelet to authenticate itself to the API server and establish a secure connection.

- **Client Certificates**: In some cases, clients (such as external services or controllers) may also need certificates to authenticate themselves to the Kubernetes API server. These client certificates are issued by the Cluster CA and are used for secure communication.



#### **Certificate Verification:**
- Get a node-shell for any of the nodes
- the certs are stored at `/etc/kubernetes/certs`. There are 3 certs
	- apiserver.crt
	- ca.crt : (expires in 30 years)
	- kubeletserver.crt : (expires in 20 years)
- To view the expiry date of ths certs use command `openssl x509 -in <cert-name> -noout-enddate`


## Network Policies

In Azure Kubernetes Service (AKS), network policies serve as firewalls for pods, allowing you to control and restrict network traffic between pods within your cluster. By default, all pods within a cluster can communicate with each other without any restrictions. However, network policies enable you to enforce security measures and follow the principle of least privilege by allowing only specific traffic between pods.

Azure AKS supports two main implementations of network policies:

1. **Azure Network Policy Manager (NPM)**: This is Azure's own implementation of network policies for AKS. Azure NPM is designed to work specifically with Azure CNI (Container Network Interface), which is the default networking plugin for AKS clusters. It allows you to define network policies at the IP address or port level to restrict traffic between pods within your cluster.

2. **Calico Network Policies**: Calico is an open-source networking and network security solution that provides advanced network policy capabilities for Kubernetes clusters. Calico supports both Azure CNI and Kubenet networking plugins. It offers features such as global network policies, which allow you to define policies that span multiple namespaces.

When creating an AKS cluster, you can specify the type of network policy implementation you want to use by configuring the `--network-policy {azure/calico}` flag. You can choose either "Azure" for Azure NPM or "Calico" for Calico network policies.

*It's important to note that network policies only take effect if the network policy feature is enabled for your AKS cluster. Without enabling this feature, any network policies you define will have no effect on the traffic within your cluster. You cannot enable Network Policies once the cluster is created*


We will explore Azure Network Policy within an Azure Kubernetes Service (AKS) cluster. We'll start by creating a new AKS cluster using the Azure CLI, enabling Azure CNI as the network plugin. Then, we'll dive into hands-on activities within the cluster, including:

1. Creating a new namespace and deploying two Nginx pods (client and server). Initially we will be able to curl from client to server
2. Create and apply network policies to restrict ingress traffic to the server pod, allowing access only from the client pod.
3. Verifying the effect of the network policy on iptables rules and pod connectivity.
4. Implementing an egress policy to allow DNS resolution for the cluster.
5. Testing and validating the network policies' enforcement and connectivity.


1. **Creating the Cluster**: The `--network-plugin azure` flag is used to specify Azure CNI as the network plugin, which is required for Azure Network Policy. The flag `--network-policy azure` is used to enable Azure NPM network policy
```bash
# enable azure npm network policy
az aks create --resource-group <rg-name> --name <cluster-name> --node-count 2 --network-plugin azure --network-policy azure
```
- Azure NPM functionality is implemented using a daemonset named `azure-npm` in the kube-system namespace
```bash
kubectl get ds -n kube-system
```

2. **Namespace and Pods Creation**: 
```bash
# create namespace 
kubectl create ns demo

# update demo as the default namespace

# create client nginx pod
kubectl run client --image nginx

# create server nginx pod
kubectl run server --image nginx 
```
- creating a pod using a the run command adds the label `run: server` to the pod
- get node-shell access to the node running client pod and see the iptable rules if any for client. We would not see any rules related to client at the moment
- We are checkig iptable rules becuase Azure NPM uses iptable to achive ehat kubernetes network policies asks for
```bash
iptables -S | grep client
```
- test connectivity to the server pod from client pod. 
```bash
# inside the client pod
curl --connect-timeout 5 <ip-of-server-pod>
```

3. **Creating a Network Policy**: we will create a  network policy named to restrict ingress traffic to the "server" pod. This policy specified that traffic from pods labeled as "app=client" on port 80 should be allowed. However, since our "client" pod did not have this label, traffic from it to the "server" pod will be blocked. Also , since we only added the rule for port 80 , traffic to only that port will be blocked from the client pod , other ports will still work
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: demo-policy
  namespace: demo
spec:
  podSelector:
    matchLabels:
      run: server
  policyTypes:
    - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: client
    ports:
    - port: 80
      protocol: TCP
```
- **spec:** Defines the specifications or rules for the network policy.
   - **podSelector:** Specifies the pods to which the network policy applies based on their labels.
      - **matchLabels:** Matches pods labeled with `run: server`.
   - **policyTypes:** Indicates the types of policy rules. In this case, it's set to `Ingress`, meaning it controls incoming traffic.
   - **ingress:** Defines the rules for incoming traffic.
     - **from:** Specifies the sources from which traffic is allowed.
       - **podSelector:** Selects pods from which traffic is allowed based on their labels.
         - **matchLabels:** Matches pods labeled with `app: client`.
     - **ports:** Specifies the ports on which incoming traffic is allowed.
       - **port:** Specifies the port number, which is 80.
       - **protocol:** Specifies the protocol of the allowed traffic, which is TCP.

Overall, this network policy only allows incoming traffic on port 80 from pods labeled with `app: client` to pods labeled with `run: server` within the `demo` namespace.

- testing connectivity to the server pod from client pod results in a time out 
```bash
# inside the client pod
curl --connect-timeout 5 <ip-of-server-pod>
```
- checkinh iptable rules on the node , we see that a new rule is added that allows traffic for only those pods that has the lable `app: client`
```bash
iptables -S | grep client
```
- if you update the label of the pod to `app: client` , you would be able to connect .

5. **Egress Policy**: 
Egress traffic refers to the network traffic leaving the pod and going out to external destinations or services outside of the Kubernetes cluster. It typically includes any data packets originating from the applications running within the pod and being sent to external servers, services, or networks.

Examples of egress traffic include:

1. Outgoing HTTP requests to external APIs or web services.
2. Database queries sent to remote database servers.
3. External service calls to cloud services like storage, messaging, or authentication services.

- by default , the pods will be able to send egress traffic to everywhere
```bash
# curl from the sever pod
curl --connect-timeout 5 kubernetes.io -v
```
- the above command resolved the ip 147.75.40.148
- to control egress traffic we will use a egress policy

The egress section in a Kubernetes Network Policy YAML file defines rules for controlling outbound traffic from pods. Let's break down its different parts:

1. **Egress Rules**: The egress section starts with a list of egress rules. Each rule specifies conditions under which egress traffic is allowed from pods.
2. **To**: This field specifies the destination of the egress traffic. It can have different forms:
   - `ipBlock`: Allows traffic to specific IP addresses or CIDR blocks.
   - `namespaceSelector`: Allows traffic to pods in namespaces matching certain labels.
   - `podSelector`: Allows traffic to specific pods within the same or different namespaces, based on their labels.
   - `serviceName`: Allows traffic to pods associated with a Kubernetes service.
3. **Ports**: This field specifies the allowed ports and protocols for outbound traffic. It typically includes the following subfields:
   - `port`: Specifies the destination port number or range.
   - `protocol`: Specifies the protocol used (e.g., TCP, UDP).
4. **Policy Enforcement**: The egress rules define the policy for allowing or denying outbound traffic based on the specified conditions. If a pod's egress traffic matches any of the defined rules, it is allowed; otherwise, it is denied.
5. **Default Deny**: If no egress rules are specified, Kubernetes follows a default deny policy for egress traffic. This means that all outbound traffic is denied unless explicitly allowed by a network policy.


```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: demo-policy
  namespace: demo
spec:
  podSelector:
    matchLabels:
      run: server
  policyTypes:
    - Ingress
    - Egress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: client
    ports:
    - port: 80
      protocol: TCP
  egress:
    - to:
        - ipBlock:
            cidr: 147.75.40.148/32
```
- in the above yaml , Rule 1 Allows egress traffic to a specific IP block (147.75.40.148/32). This rule allows outbound traffic destined for the specified IP address range.

- Now , when you use `curl kuberentes.io` again , it would result in timeout, because we have enabled egress traffic to only one ip . We will be able to curl directly to the ip adress ie `curl 147.75.40.148` would not timeout. thsis is because , we had only one egress rule and that was for an ip address only , that is why the dns resoltion wont work but the direct ip would work
- To enable DNS resolution, we added another egress rule targeting the CoreDNS pods.

```yaml
  egress:
    - to:
        - ipBlock:
            cidr: 147.75.40.148/32
    - to:
        - namespaceSelector: {}
          podSelector:
            matchLabels:
              k8s-app: kube-dns
      ports:
        - port: 53
          protocol: UDP
```

- The new rule added above Allows egress traffic from pods within a specific namespace and with specific labels.
  - `namespaceSelector`: {} selects all namespaces.
  - `podSelector` specifies pods with the label k8s-app: kube-dns.
  - `ports `specifies the allowed ports and protocols for outbound traffic.
    - port: 53 specifies the destination port number (53 is the standard port for DNS).
    - `protocol`: UDP specifies the protocol used (in this case, UDP for DNS).
- This rule allows traffic to CoreDNS pods for DNS queries by specifying port 53 for UDP protocol.
- After applying these changes, `curl kubernetes.io` successfully resolved and connected, indicating DNS resolution now works. `curl microsoft.com` would also work cuase the pod can send exgress traffic to coredns pods for domain resolution
- However, attempts to connect to other IP's diretly resultes in timeouts, as egress to other IPs was restricted





