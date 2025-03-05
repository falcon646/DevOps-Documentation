# **Storage Service Encryption (SSE) and Azure Disk Encryption**  

Azure provides **built-in encryption mechanisms** to protect data at rest and in transit, ensuring compliance with **security and regulatory requirements**.  



## **Storage Service Encryption (SSE) aka Server-Side Encryption**  

**SSE**, also known as **Server-Side Encryption**, automatically encrypts all data stored in **Azure Storage** services, including:  
- **Azure Disk**  
- **Blob Storage**  
- **Azure Files**  
- **Queue Storage**  
- **Table Storage**  

This encryption is **completely transparent** and does not require any changes to applications.  



### **Key Benefits of SSE**  

#### **1. Data Protection**  
- **Data at rest** is encrypted using **AES-256-bit encryption**, ensuring high security standards.  
- Data is **automatically decrypted** when accessed.  

#### **2. Compliance**  
- Organizations can meet **security and compliance** requirements without **developing custom encryption solutions**.  
- SSE is compliant with **ISO, SOC, HIPAA, and GDPR** security standards.  

#### **3. Strong Encryption**  
- Uses **Advanced Encryption Standard (AES) 256-bit encryption** to secure data.  
- Encryption, **decryption, and key management** are handled entirely by **Azure Storage**.  

#### **4. Always Enabled**  
- **SSE is enabled by default** for all storage accounts.  
- **It cannot be disabled**, ensuring continuous protection.  



### **Customer-Managed Encryption (BYOK - Bring Your Own Key)**  

By default, Azure manages encryption keys (**Microsoft Managed Keys**). However, organizations that require **full control** over encryption keys can use **Customer Managed Keys (CMK)**.  

#### **Steps to Use Customer Managed Keys**  
1. **Create an Azure Key Vault** to store encryption keys.  
2. **Enable customer-managed encryption** on the storage account.  
3. The **Storage Service retrieves the key from Azure Key Vault** for encryption and decryption.  
4. Organizations can **rotate and manage keys** as per their internal security policies.  



## **Azure Disk Encryption (ADE)**  

Azure Disk Encryption (**ADE**) provides encryption for **OS and data disks** of **Windows and Linux virtual machines** in Azure. This prevents unauthorized access to disk data, even if the disk is **copied, downloaded, or attached to another VM**.  



### **How Azure Disk Encryption Works**  

1. **Encryption Mechanism**  
   - **Windows**: Uses **BitLocker** to encrypt disks.  
   - **Linux**: Uses **dm-crypt** for encryption.  
   - **256-bit AES encryption** is used to secure disk data.  

2. **Key Management**  
   - Encryption keys are stored in **Azure Key Vault**.  
   - Only the **VM owner** has access to the decryption keys.  

3. **Prevents Unauthorized Access**  
   - If a **VHD file** is downloaded and attached to another VM, the data remains **inaccessible** without the decryption keys.  

4. **Encrypted Backup Support**  
   - Azure Backup encrypts data **before storing it** in the **Recovery Services Vault**.  
   - Encryption keys are backed up for recovery.  



### **Considerations for Using Azure Disk Encryption**  

1. **Performance Impact**  
   - Encrypting both **OS and data disks** may cause a **slight performance impact** due to encryption and decryption processes.  
   - If the VM is **CPU-intensive**, encrypting **only the data disk** is recommended to **reduce performance overhead**.  

2. **Customer Managed Keys (CMK) Limitation**  
   - **ADE cannot be used** if **Server-Side Encryption (SSE) is enabled with CMK**.  
   - ADE requires **Platform Managed Keys (PMK)** for encryption.  



### **Encryption at Host (EAH)**  

Azure also provides **Encryption at Host (EAH)**, which encrypts **VM disks before writing data** to the storage infrastructure.  

- **Requires VM shutdown** before enabling.  
- **Encryption at Host** applies to all **temporary and persistent disks** attached to the VM.  



### **Enabling Azure Disk Encryption in Azure Portal**  

1. **Go to the Azure Portal** → **Storage Account** → **Encryption**  
   - **Check the current encryption model** (Microsoft Managed Keys by default).  
   - **Switch to Customer Managed Keys (CMK)** (applicable only for **Blobs and Files**).  

2. **Enabling ADE for a Virtual Machine**  
   - Navigate to **Virtual Machines** → **Select VM** → **Disks** → **Additional Settings**.  
   - Choose to encrypt **OS Disk, Data Disk, or both**.  
   - **Restart the VM** to apply the changes.  

3. **Enabling Encryption at Host**  
   - The VM must be **stopped** before enabling this option.  



### **Conclusion**  

Azure **Storage Service Encryption (SSE)** ensures **seamless and strong encryption** of data at rest. Organizations can use **Microsoft Managed Keys** for automated key management or opt for **Customer Managed Keys** for greater control. **SSE is always enabled**, securing all stored data **without requiring any additional configuration**.

**Azure Disk Encryption (ADE)** ensures **data protection** by encrypting **OS and data disks** using **BitLocker (Windows) and dm-crypt (Linux)**. Organizations can use **Azure Key Vault** for encryption key management. **ADE is best suited for securing VM disks** in compliance-driven environments, while **Encryption at Host (EAH)** provides an additional security layer for **full-disk encryption** before data is written to Azure Storage.