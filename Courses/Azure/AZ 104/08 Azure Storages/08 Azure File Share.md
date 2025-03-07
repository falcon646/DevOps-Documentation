### **Creating and Using Azure File Share**  

Azure File Share provides **enterprise-grade** file storage in the cloud, allowing multiple virtual machines (VMs) and non-Azure workloads to share files seamlessly. It supports **Windows, Linux, and macOS**, offering easy mounting options via **SMB and NFS** protocols.  



### **Key Features of Azure File Share**  
- **Cloud-based file sharing**: Allows Azure and non-Azure VMs to mount and use the file share simultaneously.  
- **Supports SMB & NFS**: Enables both **Windows-based (SMB 3.0/3.1.1)** and **Linux/macOS-based (NFS 4.1)** workloads.  
- **Backup and snapshots**: Supports **data recovery** via snapshots and Azure Backup.  
- **Seamless access**: Computers interact with Azure File Share **just like an on-premises file share**.  
- **Port 445 requirement**: **SMB traffic requires port 445** to be open in the firewall, but some ISPs may block it.  



### **Use Cases**  
- **On-premises file server migration**: Organizations can decommission local file servers and migrate to Azure Files.  
- **Shared tools and utilities**: Teams can store and access shared scripts, logs, and configuration files.  
- **Diagnostic data storage**: Application logs and monitoring data can be centrally stored in a shared location.  



### **Creating an Azure File Share in Azure Portal**  

1. **Navigate to Azure Portal** → Go to **Storage Accounts**.  
2. Select an existing **storage account** or create a new one.  
3. Under **File shares**, click **Add File Share**.  
4. Provide a **name** (e.g., `Files01`).  
5. Choose a **performance tier**:  
   - **Transaction Optimized** – Best for applications that use Azure Files as a backend store.  
   - **Hot Tier** – Suitable for frequently accessed files.  
   - **Cool Tier** – Cost-effective for infrequently accessed data.  
6. Specify the **capacity limit** (up to 5 TB per file share).  
7. Click **Review + Create** → **Create**.  



### **Mounting Azure File Share on Windows, Linux, or macOS**  

Once the file share is created, it needs to be **mounted on a machine** to use it as a network drive.  

1. **In the Azure Portal**, go to **File Share → Connect**.  
2. Select the **operating system** (**Windows, Linux, or macOS**).  
3. **Click "Show Script"** to generate the mount command.  
4. **Ensure Port 445 is open** on your network to allow SMB traffic.  
5. **Run the script** on the target machine to mount the file share.  

For example, on Windows:  
- Running the script **automatically mounts the file share as a network drive** (e.g., `Z:\`).  
- Users can access the drive via **File Explorer** and create files, which will be synced to Azure.  



### **Security Considerations**  
- **Public Internet Access**: By default, Azure File Share is accessible over the public internet.  
- **Secure Access**: Options include **private endpoints, Azure Virtual Network (VNet) integration, and firewalls**.  
- **Authentication**: Supports **Azure AD Kerberos authentication** for enhanced security.  

Azure File Share provides a **scalable, secure, and cost-effective** way to manage file storage while ensuring **high availability and accessibility**.