### Understanding the Azure Hierarchy

In Azure, effective management and organization of resources are essential for maintaining a well-structured cloud environment. Azure's hierarchy provides a comprehensive framework for organizing, managing, and securing multiple subscriptions and their associated resources. Understanding this hierarchy is crucial for leveraging Azure’s capabilities in policy enforcement, access management, and cost control.

**Azure Hierarchy Structure**

`Scope` : **Management Groups** → **Subscriptions** → **Resource Groups** → **Resources** 

1. **Management Groups**  
   - At the top of the hierarchy, management groups offer a level of scope above individual subscriptions.  
   - These allow multiple subscriptions to be grouped together for unified management.  
   - By default, Azure creates a root management group for an organization.  
   - Up to **six levels of nested management groups** can be created (excluding the root group), allowing a multi-tiered structure.  
   - For example, within the root management group, an organization might have separate groups for IT and Finance, and further divisions within IT for Production and Development.

2. **Subscriptions**  
   - Subscriptions exist under management groups and serve as containers for Azure services.  
   - They provide billing and administrative boundaries, ensuring that projects or departments can be managed independently.

3. **Resource Groups**  
   - Within each subscription, **resource groups** serve as logical containers for related resources.  
   - They help in organizing virtual machines, databases, storage accounts, and other resources efficiently.

4. **Resources**  
   - The lowest level in the hierarchy consists of **individual Azure resources** such as virtual machines, databases, and networking components.  
   - These resources belong to specific resource groups, which in turn are associated with subscriptions and management groups.

**Practical Benefits of the Azure Hierarchy**

- **Policy and Access Management**  
  - Policies and permissions can be applied at broader levels (e.g., a management group), ensuring consistency across all underlying subscriptions and resource groups.  
  - Access at a higher level **automatically propagates** down to child resources, reducing administrative overhead.  
  - For instance, granting access at the IT management group level means users automatically receive permissions across all IT-related subscriptions and resources.

- **Cost Management**  
  - Budgets and spending policies can be applied at different levels, enabling better financial control.  
  - Grouping subscriptions under management groups allows organizations to track and manage cloud costs effectively.

Azure’s hierarchical structure provides **scalability, governance, and security**, ensuring organizations can efficiently manage cloud environments with minimal complexity.

### **Building a Hierarchy with Azure Management Groups in the Azure Portal**

Azure provides management groups as a way to organize and structure multiple subscriptions within an organization. This hierarchy plays a critical role in applying **Role-Based Access Control (RBAC)** policies and managing costs efficiently. The following steps outline how to create and manage management groups within the **Azure portal**.

**Navigating to Management Groups**
1. Open the **Azure portal** and navigate to **Management Groups**.
2. The root management group is displayed by default.  
   - Under this, existing subscriptions and nested management groups are listed.

**Creating a New Management Group**
1. Click on **Create a Management Group**.
2. Enter a **unique Group ID** (e.g., `AZ-104`) and a **display name**.
3. Confirm the creation of the new management group.

Once created, the management group will be visible in the hierarchy but will not contain any subscriptions.

**Moving Subscriptions into a Management Group**
1. Open the newly created **AZ-104** management group.
2. Select the **"Add Subscription"** option.
3. Choose the subscriptions to move under `AZ-104`.
4. Confirm the selection, and the subscriptions will now be grouped under `AZ-104`.

**Rearranging Subscriptions in the Hierarchy**
- Subscriptions can be moved between management groups.  
- Select a subscription, click on the **“Move”** option, and choose the target management group (e.g., move a subscription from the **root group** to **IT**).
- Click **Save** to apply the changes.

**Reviewing the Hierarchy**
After refreshing the portal, the updated management group structure will be displayed. Expanding the hierarchy provides a **clear view of how subscriptions are organized**.

#### **Importance of the Hierarchy**
- **RBAC Policy Application**: Permissions assigned at higher levels propagate downward, simplifying access management.  
- **Cost Management**: Grouping subscriptions under a management group allows better tracking and cost allocation.  
- **Organizational Efficiency**: A well-structured hierarchy ensures scalability and governance.
