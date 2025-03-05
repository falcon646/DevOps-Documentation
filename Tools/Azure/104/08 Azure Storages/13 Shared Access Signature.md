

### **Shared Access Signature (SAS) in Azure**  

A **Shared Access Signature (SAS)** in Azure is a **secure mechanism** to grant fine-grained access to storage resources **without exposing storage account keys**. SAS allows defining **time-limited permissions** for accessing **Blobs, Queues, Tables, or Files**, ensuring controlled access to data.  

### **Key Features of SAS**  
- **Granular Access Control**: SAS enables defining **specific permissions** (e.g., Read, Write, Delete, List).  
- **Time-limited Access**: Access can be restricted to a **defined period**.  
- **Resource-specific Permissions**: SAS can be scoped to **specific services or entire accounts**.  
- **Improved Security**: Eliminates the need to share **account keys**, reducing exposure risks.  

### **Types of Shared Access Signatures**  

1. **Service SAS**  
   - Grants access to specific **resources** within a **storage account**.  
   - Provides **fine-grained control** over operations at the service level.  

2. **Account SAS**  
   - Provides access to **multiple services** (Blobs, Files, Queues, Tables) within a storage account.  
   - Offers **broader permissions** compared to Service SAS.  

3. **User Delegated SAS**  
   - Secured using **Microsoft Entra ID (Azure AD)**.  
   - Allows delegating access to a client **without exposing account keys**.  

### **Structure of a Shared Access Signature (SAS)**  

A **SAS** consists of two key components:  
1. **Resource Endpoint**: The URL of the resource being accessed (e.g., Blob, Queue, Table).  
2. **SAS Token**: A token appended to the resource endpoint containing various parameters.  

#### **SAS Token Parameters**  

A SAS token includes multiple parameters that define its scope:  

![sastoken](images/sastoken.png)

### **Conclusion**  
A **Shared Access Signature (SAS)** is a powerful tool for **controlling access** to Azure Storage resources. It enhances security by **eliminating direct exposure** of storage account keys while providing **fine-grained access control**.  


## **Using SAS Tokens to Secure Blob Storage Access**  

In Azure, **Shared Access Signature (SAS) tokens** provide **temporary, restricted access** to storage resources. Unlike public access, SAS tokens offer **fine-grained control** over permissions, expiration time, and allowed IP addresses.  



### **Steps to Configure SAS for Blob Storage**  

1. **Changing Blob Access Level**  
   - Navigate to **Azure Portal** → **Storage Account** → **Containers**.  
   - Select a container (e.g., `Images`).  
   - Change **access level** to `Blob` (allows anonymous access).  
   - Copy and paste the **blob URL** in the browser to verify public access. It should work if the access in public 

2. **Restricting Public Access**  
   - Change **access level** to `Private` (disables anonymous access).  

3. **Generating SAS Token**  
   - Return to your storage account, where you will find the Access Keys. These are the two root keys of your storage account and include both the key value and the connection string, which is useful when using the REST API.
   - Go to **Storage Account** → **Shared Access Signature**.  
   - Choose the services to which you want to grant access. In this case, select Blob access.
   - Set the permissions:
        - Grant access to the service, container, and objects with Read permissions only.
        - No need to enable versioning, write, or filter permissions.
   - Set an **expiration date** for the token.  
   - Configure **allowed IP addresses** (leave blank for all).  
   - Set **protocol** to `HTTPS only`.  
   - Choose a **signing key** (`Key 1` or `Key 2`).  
        - **Note**: Regenerating the access keys will revoke any SAS tokens generated with that key, so use caution.
   - Click **Generate SAS Token**.  

4. **Accessing the Blob Using SAS Token**  
    - Without the SAS token, accessing the URL will fail.
    - Append the SAS token to the resource URL and press Enter. You should now be able to see the intended content 
    - Copy the generated **SAS token** and append it to the blob URL:  
     ```
     <blob_url>?<SAS_token>
     ```
   - Paste the updated URL in a browser to verify access.  




### **SAS Token Expiry and Key Rotation**  

- SAS tokens are **linked to the signing key** (`Key 1` or `Key 2`).  
- **Regenerating the signing key** will **revoke all SAS tokens** generated with that key.  
- To maintain access, always update SAS tokens when **rotating keys**.  



### **Security Best Practices for SAS Tokens**  

1. **Use the least privileges** needed (e.g., Read-only access).  
2. **Set short expiration times** to limit risk exposure.  
3. **Restrict access to specific IP ranges** when possible.  
4. **Use Azure Key Vault** for secure key management.  



