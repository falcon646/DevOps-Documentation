### **Azure Resource Locks: Preventing Accidental Modifications and Deletions**  

Azure **Resource Locks** provide an additional layer of protection to prevent accidental deletions or modifications of critical resources. These locks act as safeguards, ensuring that essential configurations remain intact even during routine maintenance or scripting.  

**How Resource Locks Work**  
- **Protection Against Accidental Changes**  
   - Resource locks **prevent unintended deletions or modifications** of Azure resources.  
   - For example, if a **DNS domain** is locked, it **cannot be deleted** without explicitly removing the lock first.  

- **Lock Inheritance**  
   - Locks can be applied at different levels:  
     - **Subscription Level** → Affects all resources under the subscription.  
     - **Resource Group Level** → Applies to all resources within the group.  
     - **Resource Level** → Only affects the specific resource.  
   - If a lock is applied at the **Resource Group level**, all underlying resources automatically inherit the lock.  

**Types of Resource Locks**   : Azure provides **two types of resource locks**, each serving a different purpose:  

1. **Read-Only Lock** (`ReadOnly`)  
   - Prevents any modifications to the resource.  
   - Users can **view** the resource but **cannot make changes**.  
   - Example: **Locking a production database** to prevent unauthorized modifications.  

2. **Delete Lock** (`CanNotDelete`)  
   - Allows modifications but **prevents resource deletion**.  
   - Example: **Protecting a virtual machine** that requires frequent updates but must not be deleted.  

**Implementing Resource Locks in Azure**  

1. **Navigate to the Azure Portal**  
   - Go to **All Resources** and select the resource to protect.  

2. **Access the Locks Section**  
   - Click on **Locks** in the resource settings.  

3. **Create a New Lock**  
   - Click **+ Add** to create a new lock.  
   - Choose a **Lock Name**, select the **Lock Type** (`ReadOnly` or `CanNotDelete`), and save the changes.  

4. **Managing Locks**  
   - **Modifying a Lock** → Edit the existing lock settings.  
   - **Removing a Lock** → Unlocking the resource requires manually deleting the lock.  

### **Implementing and Managing Resource Locks in Azure**  

Azure **Resource Locks** provide a critical safeguard against accidental deletions or modifications of important resources. By applying these locks, organizations can ensure that essential services remain protected, minimizing risks during maintenance or automation tasks.  

**Applying a Delete Lock on a Resource**  

1. **Navigate to the Azure Portal**  
   - Go to **Resource Groups** and select a specific **Resource Group**.  
   - Choose a **resource** (e.g., an **Automation Account**).  

2. **Adding a Delete Lock**  
   - Locate **Locks** in the left-hand menu.  
   - Click **+ Add** to create a new lock.  
   - Set the **Lock Name** (e.g., `DND` for "Do Not Delete").  
   - Select **Lock Type** → `Delete`.  
   - Optionally, add a **note** for other users.  
   - Click **Save** to apply the lock.  

3. **Testing the Delete Lock**  
   - Navigate back to the **resource overview**.  
   - Attempt to **delete** the resource.  
   - The operation will fail, showing a message indicating that the **resource is locked**.  
   - The lock must be **explicitly removed** before deletion.  

**Converting to a Read-Only Lock**  

1. **Removing the Delete Lock**  
   - Go to **Locks** in the resource settings.  
   - Select the existing **Delete Lock** and remove it.  

2. **Applying a Read-Only Lock**  
   - Create a **new lock** with:  
     - **Lock Name** → `RO` (Read-Only).  
     - **Lock Type** → `ReadOnly`.  
   - Save the changes.  

3. **Testing the Read-Only Lock**  
   - Try modifying the resource (e.g., creating a **new Runbook** inside an **Automation Account**).  
   - The action will **fail** with a message stating that the resource is **locked for modifications**.  

**Inheritance of Locks at Different Levels**  

Locks **inherit down the hierarchy**, meaning:  

- **Resource-Level Lock** → Affects only that specific resource.  
- **Resource Group Lock** → Applies to **all resources** within that group.  
- **Subscription-Level Lock** → Propagates to **all resources** under the subscription.  

**Example: Applying a Lock at the Resource Group Level**  

1. **Navigate to the Resource Group**.  
2. **Go to Locks** and add a **new lock**:  
   - Lock Name: `RG_Lock`.  
   - Lock Type: `Delete`.  
   - Save the configuration.  

3. **Verifying Lock Inheritance**  
   - Open any resource within the **Resource Group** (e.g., a **Virtual Machine**).  
   - Go to **Locks**, and the **inherited lock** should be visible.  
   - Try deleting the VM → The deletion will fail due to the inherited lock.  

