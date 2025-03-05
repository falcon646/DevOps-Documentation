

### **Accessing Storage Endpoints in Azure**  

Each storage account in Azure has unique **endpoints** based on the storage account name and the service being accessed. The endpoint structure follows a specific format:  

#### **Endpoint Format:**  
```
<protocol>://<storage-account-name>.<service>.core.windows.net
```
- **Protocol**: `HTTP` or `HTTPS`  
- **Storage Account Name**: The unique name of the storage account  
- **Service**: The specific storage service (`blob`, `queue`, `file`, or `table`)  
- **Domain**: `.core.windows.net`  

#### **Example:**  
For a storage account named **KodeKloud**, the endpoints will be:  
- `https://kodekloud.blob.core.windows.net` (Blob Storage)  
- `https://kodekloud.queue.core.windows.net` (Queue Storage)  
- `https://kodekloud.file.core.windows.net` (File Storage)  
- `https://kodekloud.table.core.windows.net` (Table Storage)  

Since **storage account names must be globally unique**, users may need to modify names (e.g., by adding numbers or letters) to ensure uniqueness.  


### **Custom Domains for Storage Accounts**  
To enhance branding and trust, a **custom domain** can be mapped to a storage endpoint.  
For example, instead of using `kodekloud.blob.core.windows.net`, a custom domain such as:  
```
blobs.kodekloud.com → kodekloud.blob.core.windows.net
```
can be used. This makes the URL more professional and prevents it from looking suspicious.  



### **Tools for Accessing Azure Storage**  

Several tools are available for managing and interacting with Azure Storage:  

1. **Azure Storage Explorer** (GUI Tool)  
   - A desktop application for managing storage accounts.  
   - Supports drag-and-drop operations, file deletion, and other management tasks.  

2. **Import/Export Service** (Data Migration)  
   - Designed for customers with large datasets (terabytes or petabytes) stored on-premises.  
   - Data is encrypted and physically shipped to an Azure Data Center, where it is copied into an Azure Storage account.  

3. **AZCopy** (Command-Line Tool)  
   - A CLI tool for transferring data between storage accounts or cloud providers (Azure, AWS, GCP).  
   - Supports automation and disaster recovery (DR) scenarios.  



### **Finding Storage Endpoints in Azure Portal**  
- Navigate to the **Storage Account** in Azure Portal.  
- Under **Settings → Endpoints**, all storage service URLs will be displayed.  
- The portal provides access to endpoints for:  
  - **Blob Storage**  
  - **File Shares**  
  - **Queues**  
  - **Tables**  
  - **Static Website Hosting**  
  - **Azure Data Lake Storage** (for analytics)  

