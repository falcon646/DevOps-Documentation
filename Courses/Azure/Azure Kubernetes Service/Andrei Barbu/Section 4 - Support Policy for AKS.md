# Support Policy 
https://learn.microsoft.com/en-us/azure/aks/support-policies

**`Do's`:**

1. **Check release notes and roadmap:**
   - Regularly review AKS release notes to stay informed about updates, bug fixes, and new features.
   - Monitor the AKS roadmap to understand upcoming changes, enhancements, and preview features that may impact your deployment.

2. **Understand managed features:**
   - Recognize that AKS offers a managed Kubernetes service, providing a simplified deployment experience with fewer customization options compared to managing Kubernetes clusters directly.
   - Appreciate that AKS offers a fully managed control plane, including components like Kubelet, Kubernetes API servers, etcd, DNS services, and networking, operated and maintained by Microsoft.

3. **Follow shared responsibility model:**
   - Acknowledge the shared responsibility model where Microsoft manages certain aspects, such as the control plane, while users are responsible for agent node maintenance, including applying OS security patches and adhering to best practices for cluster management.

4. **Ensure AKS support coverage:**
   - Understand the scope of Microsoft's technical support, which includes connectivity to Kubernetes components, management of control plane services, support for etcd data store, and assistance with networking-related issues.
   - Know that Microsoft provides support for integration points with Azure services, such as load balancers and persistent volumes.

5. **Adhere to security and patching practices:**
   - Implement a patch management strategy to ensure timely updates of agent node OS and runtime components.
   - Remain vigilant for security advisories from Microsoft and promptly apply patches to mitigate vulnerabilities in managed AKS components.

6. **Maintain agent nodes responsibly:**
   - Refrain from making direct modifications to agent nodes using IaaS APIs, as doing so may result in an unsupported cluster configuration.
   - Utilize Kubernetes daemon sets for deploying workload-specific configurations or third-party software packages on cluster nodes.

7. **Handle node maintenance and access cautiously:**
   - Exercise caution when accessing and modifying agent nodes to prevent unintended changes that could lead to an unsupportable cluster state.
   - Limit customization of network security groups (NSGs) to custom subnets and ensure compliance with AKS egress requirements to maintain network security.

8. **Stop AKS clusters appropriately:**
   - Use the `az aks stop` command to gracefully stop clusters during periods of inactivity, preserving cluster state for up to 12 months.
   - Avoid manually deallocating cluster nodes or performing unsupported operations, as these actions may result in an unsupported cluster configuration.

**`Don'ts`**

1. **Avoid unsupported scenarios:**
   - Refrain from seeking Microsoft support for Kubernetes usage questions, such as custom ingress controller configurations or third-party software package deployments.
   - Exercise caution when utilizing alpha features or preview features in production environments, as these may lack stability and comprehensive support.

2. **Don't perform unsupported operations:**
   - Avoid making direct modifications to agent nodes using IaaS APIs or resources outside of the AKS API, as this can lead to cluster unsupportability.
   - Prohibit manual deallocation of cluster nodes or manual customizations to ensure compliance with AKS support guidelines and prevent potential service disruptions.

3. **Prevent cluster unsupportability:**
   - Ensure that changes made to agent nodes, including metadata and extensions, are performed using Kubernetes-native mechanisms to maintain cluster supportability and integrity.
   - Proactively monitor and manage cluster configurations to prevent inadvertent changes that could result in an unsupported cluster state.

4. **Don't rely on unstable features:**
   - Exercise caution when utilizing preview features or feature-flagged functionalities in production environments, as these may undergo frequent changes and lack comprehensive support.
   - Understand that features in public preview may have limited support hours and are not recommended for critical workloads requiring high availability and stability.

By adhering to these technical guidelines, organizations can effectively leverage Azure Kubernetes Service while maintaining supportability, security, and reliability for their containerized workloads.

`Regarding Azure Public Load Balancer`
- https://learn.microsoft.com/en-us/azure/aks/load-balancer-standard
- We don't recommend using the Azure portal to make any outbound rule changes. When making these changes, you should go through the AKS cluster and not directly on the Load Balancer resource.
- Outbound rule changes made directly on the Load Balancer resource are removed whenever the cluster is reconciled, such as when it's stopped, started, upgraded, or scaled.
