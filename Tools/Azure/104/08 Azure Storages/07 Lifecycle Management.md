### **Azure Blob Storage Lifecycle Management**  

Azure Blob Storage Lifecycle Management helps **automate data tier transitions** and **optimize storage costs** by moving data between storage tiers (Hot, Cool, Cold, and Archive) or deleting it based on pre-defined rules.  

Instead of writing complex automation scripts, **Lifecycle Management Policies** can be used to:  
- Automatically transition blobs to **cooler tiers** based on the **last modified date**.  
- **Delete blobs and snapshots** after a specified number of days.  
- Apply **filters** to target specific blob types, such as **PDFs or MP4s**.  



### **Prerequisites for Lifecycle Management**  
- Available only for **Blob Storage** and **General Purpose v2** storage accounts.  
- If using a **General Purpose v1** storage account, it must be **upgraded to v2** to enable this feature.  



### **Capabilities of Lifecycle Management**  

1. **Policy-Based Transition**  
   - Automates moving data between storage tiers based on **last modified date**.  

2. **Blob and Snapshot Deletion**  
   - Deletes blobs or snapshots **after a set period** if they remain unmodified.  

3. **Filtering Options**  
   - Apply policies to **all blobs** or limit them to **specific types** (e.g., PDFs, MP4s).  

4. **Targeted Blob Types**  
   - Supports **Block Blobs** and **Append Blobs**.  
   - Can also apply to **versions and snapshots**.  



### **Example: Lifecycle Policy Rules**  

A typical **Lifecycle Management Policy** follows these rules:  
- **Move to Cool Tier** → If last modified **more than 60 days ago**.  
- **Move to Archive Tier** → If last modified **more than 180 days ago**.  
- **Delete Blob** → If last modified **more than 365 days ago**.  
- **Skip Recently Accessed Blobs** → Blobs rehydrated in the **last 7 days** are **excluded**.  


### **Creating a Lifecycle Management Policy**  

Lifecycle Management Policies can be created using the **Azure Portal**, **Azure CLI**, or **JSON-based configurations**.  

#### **Using Azure Portal:**  
1. **Navigate to the Storage Account** → Open **Lifecycle Management**.  
2. **Click on "Add Rule"** → Define the policy name (e.g., `Policy1`).  
3. **Apply Filters (Optional)** → Limit the rule to **specific blob types** (Block, Append) or **file types** (PDF, MP4).  
4. **Define Storage Transitions**  
   - Move to **Cool** after **60 days**.  
   - Move to **Cold** after **90 days**.  
   - Move to **Archive** after **180 days**.  
   - Delete after **365 days**.  
5. **Exclude Recently Accessed Blobs** → Skip blobs accessed within **the last 7 days**.  
6. **Review and Apply** → The policy is created, and a JSON representation is available in **code view**.  

code
```json
{
  "rules": [
    {
      "enabled": true,
      "name": "test-rule",
      "type": "Lifecycle",
      "definition": {
        "actions": {
          "version": {
            "delete": {
              "daysAfterCreationGreaterThan": 9
            }
          },
          "baseBlob": {
            "tierToCool": {
              "daysAfterModificationGreaterThan": 60
            },
            "tierToCold": {
              "daysAfterLastTierChangeGreaterThan": 7,
              "daysAfterModificationGreaterThan": 90
            },
            "tierToArchive": {
              "daysAfterLastTierChangeGreaterThan": 7,
              "daysAfterModificationGreaterThan": 180
            },
            "delete": {
              "daysAfterModificationGreaterThan": 365
            }
          },
        },
        "filters": {
          "blobTypes": [
            "blockBlob"
          ]
        }
      }
    }
  ]
}
```
### **Managing Lifecycle Policies**  
- **Multiple rules** can be created to target different blob types and resources.  
- Policies can be **enabled or disabled** as needed.  
- Azure automatically **enforces these rules**, optimizing storage costs without manual intervention.  

This allows for **efficient data management** while ensuring that infrequently accessed data is moved to cost-effective storage tiers.