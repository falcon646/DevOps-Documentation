## **Azure Role-Based Access Control (RBAC)**  

**Azure RBAC** is a security mechanism that enables precise management of **permissions and access** within an **Azure environment**. It helps organizations enforce security policies by defining **who** can access **what** resources and **where** that access applies. 

- Azure role-based access control (Azure RBAC) helps you manage who has access to Azure resources, what they can do with those resources, and what areas they have access to. Azure RBAC is an authorization system built on Azure Resource Manager that provides fine-grained access management to Azure resources

####  **Core Concepts in Azure RBAC**  

- **Security Principal ( Who ? )**  
    - A **security principal** represents the identity requesting access. This can be:  
        - **User** – An individual identity within Azure Active Directory (AAD).  
        - **Group** – A collection of users with shared permissions.  
        - **Service Principal** – An identity used by applications or services to access Azure resources.  
        - **Managed Identity** – A system-assigned or user-assigned identity managed by Azure.  

- **Role Definition ( What )**  
    - Defines the **permissions** granted to a security principal. These are written in **JSON format** and specify the **operations** a role can perform (e.g., read, write, delete). These are dfined using `Role Definition`
    - Common built-in roles:  
        - **Owner** – Full access, including resource delegation.  
        - **Contributor** – Can create and modify resources but cannot assign roles.  
        - **Reader** – Read-only access to resources.  
        - **Custom Roles** – Created with a specific set of permissions as per organizational needs.  

- **Scope of Access (Where )**  
    - The **scope** determines **where** access is granted. Access can be assigned at different levels:  
        - **Management Group** – Highest level, applies to multiple subscriptions.  
        - **Subscription** – Grants access across all resources in the subscription.  
        - **Resource Group** – Limits access to a specific resource group.  
        - **Resource** – Provides granular control over individual resources like a VM, database, or storage account. 
         eg vm , db etc 
            - Assigning a role at the **subscription level** grants permissions to **all** resources in that subscription.  
            - Assigning a role at the **resource group level** limits access to only resources in that group.
            - Example:  If a user is given the Reader role at the Subscription level, they automatically get read access to all underlying resource groups and resources.


| **Concept**          | **Definition** | **Real-World Example** |
|----------------------|----------------|------------------------|
| **Who? (Security Principal)** | The identity requesting access. | A **DevOps Engineer** needs access to manage Kubernetes clusters. |
| **What? (Role Definition)** | A set of permissions defining what actions can be performed. | The **Virtual Machine Contributor** role allows users to start, stop, and configure VMs. |
| **Where? (Scope)** | The boundary where the role applies. | A DevOps Engineer is given permissions at the **Resource Group** level instead of the entire Subscription. |
| **Role Assignment** | The combination of **Who + What + Where** that grants access. | Assigning the **Storage Blob Data Reader** role to a Data Analyst for a specific **Storage Account**. |

### **Role Assignment in Azure RBAC** 

A **role** in **Azure Role-Based Access Control (RBAC)** determines what **actions** a security principal (user, group, or service principal) can perform on Azure resources.  
- A **role assignment** is the process of linking a **security principal** to a **role definition** at a specific **scope**.    ie `Security Principal + Role Definition + Scope = Role Assignment`  
- **Types of Role Definitions**   : Azure provides two types of roles:  
    - **1. `Built-in Roles (Predefined by Azure)`**   : Azure offers several predefined roles that cover most common use cases, including:  
        - **Owner** – Full access to all resources and can delegate access roles to other users.  
        - **Contributor** – Can create and manage all resources but cannot assign roles.  
        - **Reader** – Read-only access , cannot see sensitve data &  cannot modify anythig . 
        -  **User Access Administrator** - can only delegate access roles to other users noting else .
        - **Service-Specific Roles** – Such as **Virtual Machine Contributor** (for VM management) or **Storage Blob Contributor** (for storage access).  
    - **2. `Custom Roles (User-Defined Roles)`**  : If built-in roles do not meet specific requirements, organizations can **define custom roles** with precise permissions.  

- #### **Built-in Roles**
    - **1. Owner**  
        - Has **full control** over all Azure resources.  
        - Can **delegate access** to other users by assigning roles.  
        - Example: If a user is an **Owner** of a Virtual Machine, they can **assign** the **Contributor** or **Reader** role to another user.  
    - **2. Contributor**  
        - Can **create and manage** all types of resources.  
        - **Cannot assign roles** to other users.  
        - Example: A **Contributor** can manage an **Azure Storage Account** but cannot grant **another user** access to it.  
    - **3. Reader**  
        - Has **read-only access** to all resources.  
        - **Cannot make any changes** to resources.  
        - **Cannot view** sensitive data such as **connection strings, account keys, or API keys**.  
        - Example: A **Reader** can view a **VM's configuration** but cannot **start, stop, or delete** the VM.  
    - **4. User Access Administrator**  
        - Can **manage role assignments** and **delegate access** to users.  
        - **Cannot manage resources** directly.  
        - Example: A **User Access Administrator** can assign a **Contributor** role to a user but cannot **modify** or **delete** Azure resources.


- **Role Definition Structure**   : A **role definition** is written in **JSON format** and consists of the following key components:  **Example: Contributor Role Definition**  
    ```json
    {
    "Name": "Contributor",
    "Id": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
    "IsCustom": false,
    "Description": "Grants full access to manage all resources but does not allow role assignments.",
    "Actions": [
        "*"
    ],
    "NotActions": [
        "Microsoft.Authorization/*/Delete",
        "Microsoft.Authorization/*/Write",
        "Microsoft.Authorization/elevateAccess/Action"
    ],
    "DataActions": [],
    "AssignableScopes": [
        "/"
    ]
    }
    ```
    - **Explanation of Role Definition Fields**  
        | Field | Description |  
        |--------|-----------------|  
        | **Name** | Specifies the role name (e.g., **Contributor**). |  
        | **Id** | A unique **Object ID** assigned to the role. |  
        | **IsCustom** | `true` for **custom roles**, `false` for **built-in roles**. |  
        | **Description** | Describes what the role allows. |  
        | **Actions** | Specifies the **allowed operations** (e.g., `"*"` grants full control). |  
        | **NotActions** | Defines **denied operations**, preventing certain permissions even if `"*"` is allowed. |  
        | **DataActions** | Used for **data-level permissions**, primarily in **storage** and **database** services. |  
        | **AssignableScopes** | Defines **where** the role can be assigned. The `/` (root) scope means it applies to **all** subscriptions. |  
        - Key Observations from the Contributor Role Definition**  
            - **Full Resource Management** – `"Actions": ["*"]` grants full access to manage Azure resources.  
            - **No Role Assignment Permissions** – `"NotActions": ["Microsoft.Authorization/*/Write"]` prevents role assignments.  
            - **Data Actions Not Defined** – Since **data-level access** is not required, `"DataActions": []` is empty.
#### **Azure RBAC Scope Levels:**  

| Scope Level | Permissions Apply To | Inheritance |  
|-------------|----------------------|------------|  
| **Management Group** | All **subscriptions, resource groups, and resources** under it. | Inherited by **subscriptions, resource groups, and resources**. |  
| **Subscription** | All **resource groups and resources** under it. | Inherited by **resource groups and resources**. |  
| **Resource Group** | All **resources** under the resource group. | Inherited by **resources**. |  
| **Resource** | The specific Azure **resource** (e.g., a VM, Storage Account, or Database). | No further inheritance. |  

> If a **Reader** role is assigned at the **Subscription level**, all **Resource Groups** and **Resources** within that subscription will automatically inherit the **Reader** role.  
>
> If a **Contributor** role is assigned at the **Resource Group level**, all **resources** inside that **Resource Group** will inherit the **Contributor** permissions. 

- #### Examples
    - `Scenario 1`: Managing Virtual Machines in an Organization
        - Use Case: A company has multiple virtual machines in Azure. Developers need access to manage VMs, but they should not be able to delete them.
        - RBAC Implementation:
            - Assign "`Virtual Machine Contributor`" role to the DevOps Team at the Resource Group level.
            - This allows them to start, stop, and modify VMs but prevents deletion.
            - If a developer needs higher privileges temporarily, Azure Privileged Identity Management (PIM) can grant temporary access.

    - `Scenario 2`: Securing Data Access for Finance Team
        - Use Case: The finance team needs read-only access to a Storage Account that contains financial reports, but they should not modify or delete any files.
        - RBAC Implementation:
            - Assign "`Storage Blob Data Reader`" role to the Finance Team at the Storage Account level.
            - This ensures they can view but not delete or modify files.

    - `Scenario 3`: Managing Access to Kubernetes Clusters (AKS)
        - Use Case: A company is running Kubernetes on Azure Kubernetes Service (AKS). Developers need deployment permissions, while system administrators need full control.
        - RBAC Implementation:
            - Assign "`Azure Kubernetes Service RBAC Writer`" role to developers so they can deploy applications.
            - Assign "`Azure Kubernetes Service RBAC Admin`" role to system administrators for full cluster management.

    - `Scenario 4`: RBAC Scope and Inheritance
        - Use Case: A company has multiple subscriptions for different departments:
            - Subscription: IT Department
                - Resource Group: Production Environment  → Virtual Machine: Prod-VM1
                - Resource Group: Development Environment → Virtual Machine: Dev-VM1
            - The IT Manager needs read-only access to all resources, while a Developer should only have access to the Dev-VM1 machine
        - RBAC Implementation:
            - Assign "`Reader`" role to the IT Manager at the Subscription level → Gains read access to all resources.
            - Assign "`Virtual Machine Contributor`" role to the Developer only on Dev-VM1 → Gains control over Dev-VM1 but not other resources.



### **Assigning Azure RBAC Permissions in the Azure Portal**  

Role-based access control (RBAC) permissions can be assigned directly from the **Azure Portal**. This process allows defining **who** has access, **what** actions they can perform, and **where** these permissions apply.  

**1. Creating a Resource Group for RBAC Demonstration**  
- Navigate to the **Azure Portal**.  
- Create a new **Resource Group** (e.g., **AC Demo RBAC**) in the **East Europe** region.  
- Once created, refresh the page or open the **Resource Group** directly.  

**2. Understanding Access Control (IAM) in Azure**  
- On any Azure **resource, resource group, subscription, or management group**, the **Access Control (IAM)** blade allows managing RBAC assignments.  
- This panel enables checking:  
  - **Current user access**  
  - **Other users' access**  
  - **Role assignments**  
- **Example: Checking Role Inheritance**  
    - If a user has **Owner** permissions at the **Subscription level**, this role will be **inherited** by all **Resource Groups and Resources** within that subscription.  
    - This follows the **RBAC inheritance hierarchy**, where permissions assigned at **higher levels** are **automatically inherited** by lower levels.  

**3. Assigning a Role in Azure RBAC**  
- Navigate to **Access Control (IAM)** in the Resource Group.  
- Click on **"Add Role Assignment"**.  
- Choose the appropriate **role**:  
   - Built-in roles (e.g., **Owner, Contributor, Reader**)  
   - Resource-specific roles (e.g., **ACR Image Signer, Automation Contributor**)  
- Click **Next** to select members (users, groups, or service principals).  
- Define the **scope** (e.g., **Resource Group**).  
- Click **Review + Assign**.  
- The selected users will now have the assigned role.  
- **Example: Assigning the Reader Role**  
    - **Role Definition**: **Reader** (read-only access to resources).  
    - **Scope**: **Resource Group (AC Demo RBAC)**.  
    - **Users Added**: Selected users get **read access**.  
    - **Result**: The role assignment applies to all **resources** inside the **Resource Group**.  

**4. Creating a Virtual Network and Verifying RBAC Inheritance**  
- Inside the **Resource Group**, create a **Virtual Network** (**demo VNet**).  
- Select the **same Subscription and Resource Group**.  
- Click **Create** and wait for deployment to complete.  
- **Verifying Role Assignments in the Virtual Network**  
    - Open the newly created **Virtual Network**.  
    - Navigate to **Access Control (IAM)**.  
    - Check the **role assignments**:  
    - **Inherited roles from the Resource Group** will be visible.  
    - The **Reader role** assigned at the **Resource Group level** will be **inherited** by the **Virtual Network**.  



### **Key Takeaways on RBAC Scope and Inheritance**  
- **RBAC permissions assigned at higher levels (e.g., Subscription, Resource Group) are inherited by lower levels (e.g., Resources).**  
- **To apply least privilege access, assign roles at the lowest necessary scope.**  
- **Every resource that supports RBAC will have the Access Control (IAM) blade for managing role assignments.**  
- *Checking inherited role assignments helps understand access levels at different scopes.**  
- Always follow the **Principle of Least Privilege** (PoLP) – grant only the **minimum required access**.  
- Instead of granting **permanent** access to resources, **Privileged Identity Management (PIM)** provides **just-in-time (JIT) access**.  
- This structured approach ensures that Azure resources remain secure while following the **Principle of Least Privilege (PoLP)** in role assignments.
- **Maximum role assignments per subscription:** **2,000**.  
