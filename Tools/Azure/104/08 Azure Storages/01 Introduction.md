# **Administering Azure Storage**  

This module provides an in-depth exploration of **Azure Storage**, covering its configuration, security, and management. Azure Storage is designed to be **highly available, secure, durable, scalable, and redundant**, making it a reliable solution for cloud-based data storage.  



## **Learning Objectives**  

### **1. Configuring Storage Accounts**  
A **storage account** serves as a **container** for all storage services, including:  
- **Blobs** (Object Storage)  
- **Files** (Managed SMB/NFS File Shares)  
- **Queues** (Message Storage)  
- **Tables** (NoSQL Key-Value Store)  
- **Disks** (Managed Virtual Machine Disks)  

This section covers how to **create, manage, and optimize** Azure Storage Accounts for different use cases.  



### **2. Configuring Blob Storage**  
Azure **Blob Storage** is a **highly scalable object storage service**, used for:  
- Storing **large unstructured data** (text, binary, media files)  
- Hosting **static content** for web applications  
- Backups, disaster recovery, and **data archiving**  

Key Blob Storage features include:  
- **Hot, Cool, and Archive tiers** for cost optimization  
- **Soft delete and versioning** for data protection  
- **Blob lifecycle policies** for automatic data management  



### **3. Configuring Azure Files**  
Azure **File Storage** provides fully managed **file shares** in the cloud, accessible via:  
- **SMB (Server Message Block)** → Supports Windows-based applications  
- **NFS (Network File System)** → Supports Linux-based workloads  

**Key Features:**  
- Allows **concurrent mounting** on cloud and on-premises systems  
- Supports **Azure AD authentication** and **private endpoints**  
- Can be used for **application configuration, log storage, and data migration**  



### **4. Configuring Storage Security**  
Azure Storage security ensures **data protection** and **secure access** to storage accounts.  

Key security features include:  
- **Access Keys & Shared Access Signatures (SAS)** → Provides controlled access to storage resources  
- **Storage Service Encryption (SSE)** → Encrypts data at rest using Microsoft-managed keys or customer-managed keys  
- **Network Security Rules** → Uses **firewall rules, private endpoints, and virtual network integration** to restrict access  

