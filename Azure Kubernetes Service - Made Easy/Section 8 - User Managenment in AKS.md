# User Access Managenment in AKS

## AKS authorisation and authetication
AKS provides 3 authorisation and authetication
- Local Accounts with Kubernetes RBAC
- AKS managed Azure AD integration
    - Azure AD authtication with Kubernetes RBAC
    - Azure AD authentication with Azure RBAC


### **1. Local Accounts with Kubernetes RBAC**
- by default , aks cluster is created with this option but with no integration between AKS and Azure AD 
- Here , you have the option to use native K8 approaches like client certificates , bearer tokens etc but it is quite complicated. Or you can use `az aks get-credentials` but then everone will have full access to the resources

### **2. AKS managed Azure AD integration**
- usefull when you only want to allow users to do only certain actions/access 
- Here , Azure AD is integrated with the AKS cluster 
- Once Axure Ad integragion is enabled , it is cannot be reverted back or disabled
- `OpenID Connect` is used to enable Azure ad authentication for clusters. The identity layer called `OpenID Connect` is built on top of the OAuth 2.0 protocol.
- If you have Azure ad premium capabilities, you can even make use of conditional policy and with this you can restrict more.
- You can enable just in time cluster access but these are optional.
- You have two options to control what the users can do or the authorization.
    - Azure RBAC
    - Kubernetes RBAC.

- ### **Azure RBAC**
    - uses built in or custom Azure roles that can be assigned to Azure AD users, groups or service principals at the AKS cluster level or the Kubernetes Object Level
    - Azure provides built-in roles for common scenarios, but you can also create custom roles tailored to your specific requirements. 
    - These roles can define actions at either the cluster level or the Kubernetes object level.
    - Roles can be assigned at various levels within Azure, such as at the resource group level, cluster level, or namespace level.

    **Built-in Role Example**: Azure Kubernetes Services Cluster User Role

    **Actions Included:**
    - `Microsoft.Container.Service/managedClusters/read`: Allows viewing the properties and configuration settings of an AKS cluster.
    - `Microsoft.Container.Service/managedClusters/listClusterCredential/action`: Permits retrieving cluster credentials (e.g., kubeconfig) necessary for accessing an AKS cluster.

    **Custom Role:**
    Below are examples of actions that can be used to build custom roles, categorized into AKS-level and Kubernetes-level actions.
    - **AKS-Level Actions:**
        - `Microsoft.Container.Service/managedClusters/stop/action`: Allows stopping the AKS cluster.
        - `Microsoft.Container.Service/managedClusters/start/action`: Grants permission to start the AKS cluster.

    - **Kubernetes-Level Actions:**
        - `Microsoft.Container.Service/managedClusters/apps/deployments/write`: Enables writing (creating or updating) deployments in Kubernetes.
        - `Microsoft.Container.Service/managedClusters/apps/deployments/read`: Provides read access to deployment resources in Kubernetes.
        - `Microsoft.Container.Service/managedClusters/apps/deployments/delete`: Allows deletion of deployment resources in Kubernetes.

- ### **Kubernetes RBAC**
    - this is for permissions at the kubernetes level only and required one or more groups to be designated as adminitrators ie to stop/start , upgrade the cluster etc , You'll need to make use of Azure RBAC.
    - To enable Kubernetes RBAC with Azure Ad integration, it is mandatory to have one or more groups that will be used as a group for administrators.
    - In the backend that will create `ClusterRoleBinding` for the default `ClusterRole` named `cluster-admin`, which will allow them to perform any action on any resource.
    - Then you can create `roles`, `ClusterRoles` to reference the verbs, example : get list, create ,delete the resources 
    - You can even make use of default Kubernetes `ClusterRoles` like `cluster-admin`, `admin`etc ,  which exists by default in the cluster.
    - Then you can bind using `RoleBindings` and `ClusterRoleBindings` to add groups or even to individual users.
    - Roles and RoleBindings are Kubernetes objects that apply at namespace level, while ClusterRoles and ClusterRoleBindings are at the cluster level.
    - Note:
        - even if you are using Azure AD with Kubernetes RBAC or Azure RBAC, you can still have local accounts enabled which would mean that users can run get credentials with the `--admin` flag . It  will bypass the Azure AD authorization and allow them to interact as an admin.
        - This can be seen as a non-routable backdoor or as a security breach, so it is up to you if you want to keep it enabled or disabled it.


## Azure RBAC
Azure RBAC, or Azure Role-Based Access Control, is a system for managing user access to Azure resources. It provides fine-grained access management by allowing administrators to assign permissions to users, groups, or service principals at a specific scope within an Azure subscription, resource group, or individual resource.

Key components of Azure RBAC include:

1. **Roles**: Azure RBAC provides built-in roles with different levels of permissions, such as Owner, Contributor, Reader, and custom roles. Each role defines a set of permissions that determine what actions a user can perform.

2. **Role Assignments**: Role assignments associate a role with a specific user, group, or service principal, granting them the permissions defined by that role. Role assignments can be made at different scopes, including subscription, resource group, or resource level.

3. **Scopes**: RBAC permissions can be assigned at different scopes within Azure, including subscription, resource group, or resource level. Permissions assigned at a higher scope are inherited by resources within that scope unless explicitly overridden.

4. **Azure AD**: Azure RBAC relies on Azure Active Directory (Azure AD) for authentication and authorization. Users and groups are managed in Azure AD, and RBAC uses Azure AD identities to control access to Azure resources.

By using Azure RBAC, organizations can implement least privilege principles, ensuring that users have only the permissions necessary to perform their tasks. This helps improve security by reducing the risk of unauthorized access to sensitive resources. Additionally, RBAC simplifies access management by providing a centralized way to control access across Azure services and resources.

### Setup for Azure RBAC
- **Step 1 : Ceate users in Azure AD**
    - Goto Azure Entra -> Select Users from the blade
    - Crate 2 Users , one from another team but from the same company, and the other one will be a new hire who will work into a specific namespace within our cluster
    - Since the new hire will need access to only a specific namespace , we will add her to a group
    - Create a group "aks-dev-users" and add that persion to this group. Group type is security
    - Note: give access to the above 2 users under subscription level to allow them to see resources in azure portal
        - Susbcription -> access control -> Add role assignment -> Reader -> access to user,groupor service principle -> slect members -> select the groups and users required
- **Step 2 : Enable Azure RBAC (once the cluster is created)**
    - goto Clutser Configuration blade
    - Under Autherntication and Authorisation select azure rbac. check allow kubernetes local accounts 

### Working with Azure RBAC
Once the setup is done, try accessing the cluster using the az aks get-credentials command using the 2 new users created. We realise that we are not able to access the kubeconfig file . This is because the users do not have access to the aks resource we created
- To enable the users to access the cluster kubecconfig file , we need to provide them the build in role `Azure Kubernetes Services Cluster User Role`
- Goto K8 resource -> access control -> Add role assignment -> select role `Azure Kubernetes Services Cluster User Role` ->  select members -> review and assign
- Once you give this role access , you will be able to get the kubeconfig file.
- But you still do not have access to run other kubectl commands becuase the role `Azure Kubernetes Services Cluster User Role` only provides the access to get kubeconfig file
- Henec you would need to assign another role called `Azure Kubernetes Services RBAC Reader` to allow the users to read/get the resources in most namespaces
- Similarly you can provide many build-in role to the users/groups to allow spcific actions for the user/groups
- `Azure Kubernetes Services RBAC Writer` will allow user to create resources in the k8 cluster
- To restrict the role access to specific namespace use the bwlo command
```bash
az role assignment create --role "Azure Kubernetes Service RBAC Reader" --assignee <AAD-ENTITY-ID/OBJECT_ID> --scope $AKS_ID/namespaces/<namespace-name>
```
### Custom Roles with Azure RBAC
- You can use the below template the create custom roles
- Create the role definition using the az role definition create command, setting the --role-definition to the deploy-view.json file you created in the previous step.
```bash
az role definition create --role-definition @deploy-view.json
``` 
- Assign the role definition to a user or other identity using the az role assignment create command.
```bash
az role assignment create --role "CUSTOM_ROLE_NAME" --assignee <AAD-ENTITY-ID> --scope $AKS_ID
```
- Once the Role i created , you can see it in the portal and use it just like build-in roles
```json
{
    "Name": "AKS Deployment Reader",
    "Description": "Lets you view all deployments in cluster/namespace.",
    "Actions": [],
    "NotActions": [],
    "DataActions": [
        "Microsoft.ContainerService/managedClusters/apps/deployments/read"
    ],
    "NotDataActions": [],
    "assignableScopes": [
        "/subscriptions/<YOUR SUBSCRIPTION ID>"
    ]
}
```
1. **Actions**: Actions specify the operations that users assigned to the role are allowed to perform. These can include actions like read, write, delete, and specific API operations related to Azure resources. When an action is included in the role definition, users are granted permission to perform that action on resources within the specified scope.

    - "Actions" typically refer to operations that can be performed on Azure resources themselves, such as creating, deleting, updating, or listing resources. These actions directly affect the Azure infrastructure and its components.
   - `Microsoft.ContainerService/managedClusters/read`: Allows reading properties of AKS clusters.
   - `Microsoft.ContainerService/managedClusters/write`: Allows creating, updating, or deleting AKS clusters.
   - `Microsoft.ContainerService/managedClusters/connect/action`: Allows connecting to AKS clusters.

2. **NotActions**: NotActions specify the operations that users assigned to the role are explicitly not allowed to perform, even if other permissions would grant them access. NotActions are used to deny specific actions to users or groups, regardless of other permissions they might have. If a NotAction is included in the role definition, users are explicitly prohibited from performing that action on resources within the specified scope.
   - `Microsoft.ContainerService/managedClusters/delete`: Denies the deletion of AKS clusters, even if other permissions would grant the user access.
   - `Microsoft.ContainerService/managedClusters/updateTags/action`: Denies updating tags of AKS clusters, regardless of other permissions.

3. **DataActions**: DataActions represent operations that are related to data management or access within a resource. In this custom role, the "DataActions" array contains the action "Microsoft.ContainerService/managedClusters/apps/deployments/read". This action allows users to read deployments within AKS clusters or namespaces.
    - Data actions," on the other hand, are specific operations related to managing or accessing data within a resource. These actions are often more granular and target the data or content within a resource rather than the resource itself.
   - `Microsoft.ContainerService/managedClusters/listClusterCredential/action`: Allows listing credentials for AKS clusters.
   - `Microsoft.ContainerService/managedClusters/listClusterUserCredential/action`: Allows listing user credentials for AKS clusters.

4. **NotDataActions**: NotDataActions represent data-related operations that are explicitly denied for users assigned the role. In this custom role, the "NotDataActions" array is empty, indicating that there are no specific data actions denied by this role.
   - `Microsoft.ContainerService/managedClusters/resetCredential/action`: Denies resetting credentials for AKS clusters.
   - `Microsoft.ContainerService/managedClusters/regenerateCredential/action`: Denies regenerating credentials for AKS clusters.


## Kubernetes RBAC
Kubernetes Role-Based Access Control (RBAC) allows you to control access to the resources in your Kubernetes cluster. Integrating Azure Active Directory (Azure AD) with Kubernetes RBAC provides additional capabilities for authentication and authorization, leveraging Azure AD identities and policies for access control. Here's how it typically works:

1. **Authentication**:
   - Azure AD integration enables users to authenticate against the Kubernetes cluster using their Azure AD credentials.
   - Users can use their Azure AD usernames and passwords or other supported authentication methods like Azure AD tokens or certificates to authenticate to the Kubernetes cluster.

2. **Identity Mapping**:
   - Once authenticated, Kubernetes maps Azure AD users or groups to Kubernetes users or groups.
   - This mapping allows Kubernetes to associate Azure AD identities with roles and permissions defined within the cluster's RBAC policies.

3. **Authorization**:
   - Kubernetes RBAC policies are used to define permissions for various operations within the cluster.
   - Azure AD users or groups are assigned roles or cluster roles within Kubernetes to grant them specific permissions.
   - These RBAC roles and cluster roles control access to resources like pods, services, deployments, namespaces, etc.

4. **RBAC Configuration**:
   - RBAC policies are configured using Kubernetes manifests, such as Role, ClusterRole, RoleBinding, and ClusterRoleBinding objects.
   - Role objects define sets of permissions within a namespace, while ClusterRole objects define permissions across the entire cluster.
   - RoleBinding and ClusterRoleBinding objects bind these roles to Azure AD users or groups, specifying which users or groups have access to which roles.

5. **RBAC Best Practices**:
   - Follow the principle of least privilege, granting only the permissions necessary for each user or group to perform their tasks.
   - Regularly review and audit RBAC policies to ensure they align with organizational security requirements.
   - Use Kubernetes namespaces to logically partition resources and apply RBAC policies at a granular level.
   - Implement RBAC policies for both user-facing operations and system-level operations to ensure comprehensive access control.

6. **Monitoring and Logging**:
   - Monitor authentication and authorization events within the Kubernetes cluster to detect and respond to any unauthorized access attempts.
   - Utilize logging and auditing features to track changes to RBAC policies and permissions over time.

### Setup for Kubernetes RBAC
- **Step 1 : Creating Users**
    - We will create 3 users and Groups:
        - `adminuser` : will be present in `Admin Group`
        - `edituser` : will use default k8 cluster role named `edit` and will be present in `Edit Group`
        - `testuser` : a standalone Azure AD user for which we will provide permissions to create and view deployments in test namespace.
    - All the above users and groups will be created in Azure AD
    - Give Reader access to the above users and groups to the subscription level so thta they can access the subscription on the portal
- **Step 2 : Enable Kubernetes RBAC with Azure AD**
    - goto Clutser Configuration blade
    - Under Autherntication and Authorisation select kubernetes rbac. 
    - for Cluster admin ClusterRoleBinding , select the Admin Group you created
Choose AAD group
    - check allow kubernetes local accounts
- **Step 3 : Add role assignemnts to fetcg the kubeconfig**
    - provide the `Azure Kubernetes Services Cluster User Role` to all users to connect to the clutser

### Working with Kubernetes RBAC
Now we will login into azure cli using the different users one by one and analyise what are the acccess levels

`adminuser` :
- This user has full access to the aks cluster becuase it's group was added as the `Cluster admin ClusterRoleBinding` account
- The option `Cluster admin ClusterRoleBinding` serves the purpose of granting administrative access to the entire Kubernetes cluster for members of that Azure AD group
- Members of the Azure AD group selected under this option will be assigned the cluster-admin role within Kubernetes, which provides full control over all resources in the cluster

`edituser` :
- Before the adminuser provides read access to this user, this user is able to get the kubeconfig , but is not able to run any list any resources from the clutser because it does not have read pemiissions/actions on the cluster 


**Providing Access to editUser & testuser**
- the edituser can be provided various access by the adminuser
- there is a build-in cluster role named as 'edit' in the aks cluster
  ```bash
  # view the cluster role
  kubectl get clusterrole edit

  # view the various permission this cluster role has
  kubectl get clusterrole edit -o yaml  
  ```
- to allow the edituser the edit cluster role , the adminuser will bind the edituser to the clusterrole using a `clusterrolebinding`
 ```
 # bind edituser to clusterrole named edit
 kubectl create clusterrolebinding <custom-name> --clusterrole=<cluster-role-name> --group=<group-id-from-ad>
 kubectl create clusterrolebinding editrolebind --clusterrole=edit --group=<group-id-from-ad>

 # view the clusterrolebinding created
  kubectl get clusterrolebinding
 ```
 - Simillarly , the testuser will need have access to created and view deployments in test namespace
 - Since, we do not have a existing clusterrole for the access needed for out testuser , we will create a new role
 ```bash
 kubectl create role <role-name> --verb=<list-of-actions> --resource=<type-of-resource> -n <namespace>
 kubectl create role test-user-role --verb=get,list,create --resource=deployment -n test
 # view the role created
 kubectl get role
 ```
 - Now , we create a new rolebinding
 ```bash
 kubectl create rolebinding <custom-name> --user=<service-principle> --role=<role-name> -n <namespace>
 kubectl create rolebinding test-user-rb --user=<service-principle> --role=test-user-role -n test

 # view the rolebinding
 kubectl get rolebinding
 ```
**Observtions**
- `edituser`:
    - can see pods in all namespaces
    - cannot list roles,clusterrole from any namespace
- `edituser`:
    - can only list and create deploy in test namespace
    - cannot perform any other action on any other resource in either test namespace or any other


## Local Accounts
- Any normal user can run admin level commands , by getting the kubeconfig file as admin with the admin flag ie `az aks get-credentials --resource-group aks-rg --name aks-kubernetes-rbac --overwrite-existing --admin` (only if they user has admin role assigment on the aks level ie Azure Kubernetes Service Cluster Role Admin)
- This can bee considered as a security lapse , and hence it is advisable to disable it.
- You can disable it under Cluster Confifuration blade

   

