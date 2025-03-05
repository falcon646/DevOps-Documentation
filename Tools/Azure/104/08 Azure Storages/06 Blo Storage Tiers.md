### **Azure Blob Storage Tiers**  

Azure Storage offers multiple **access tiers** to balance **cost** and **performance** based on data access patterns. The available storage tiers include **Hot, Cool, Cold, and Archive**, each optimized for different use cases.  



### **Storage Tier Overview**  

| **Tier**     | **Use Case**                           | **Storage Cost** | **Access Cost** | **Retrieval Time** |
|-|-|-|-|-|
| **Hot**     | Frequently accessed data           | High           | Low            | Immediate      |
| **Cool**    | Infrequently accessed (≥30 days)  | Lower          | Higher         | Immediate      |
| **Cold**    | Rarely accessed (≥90 days)        | Even lower     | Higher         | Immediate      |
| **Archive** | Long-term storage (months/years)  | Lowest         | Highest        | Hours          |



### **1. Hot Tier**  
- Designed for data that is accessed **frequently** and requires **low latency**.  
- **Use Case:** Real-time applications, transactional logs, frequently used files.  
- **Cost Structure:** **Higher storage cost**, but **lower access cost** for frequent reads/writes.  



### **2. Cool Tier**  
- Optimized for data that is accessed **occasionally** and stored for at least **30 days**.  
- **Use Case:** Monthly reports, backup files, disaster recovery copies.  
- **Cost Structure:** **Lower storage cost**, but **higher access cost** than the Hot Tier.  
- **Microsoft Recommendation:** Move data from Hot to Cool if it is not accessed for **30+ days** (can reduce storage costs by up to **46%**).  



### **3. Cold Tier**  
- Introduced as a middle ground between **Cool and Archive**, ideal for data that is **not accessed for at least 90 days**.  
- **Use Case:** Long-term backups, compliance records, infrequently used datasets.  
- **Cost Structure:** **Cheaper storage than Cool**, with **higher access costs**.  
- **Microsoft Recommendation:** Use Cold Tier for data that will remain untouched for **90+ days** to save on capacity costs.  



### **4. Archive Tier**  
- The **cheapest storage tier**, designed for data that is **rarely accessed** (months or years).  
- **Use Case:** Legal documents, historical records, compliance data, rarely used backups.  
- **Cost Structure:** **Lowest storage cost**, but **highest access cost** with **hours-long retrieval times**.  
- **Microsoft Recommendation:** Use Archive Tier when data **does not need immediate access** and can be rehydrated **on demand**.  



### **Choosing the Right Tier**  

When selecting a tier, consider:  
- **Access Frequency** → Regularly accessed data should stay in **Hot**, while less frequent data can move to **Cool, Cold, or Archive**.  
- **Retention Period** → Data stored for **30+ days** fits **Cool**, **90+ days** fits **Cold**, and **long-term archival** belongs in **Archive**.  
- **Cost Trade-off** → Archive saves the most money on storage but is expensive and slow to access.  



### **Configuring Storage Tiers in Azure Portal**  

1. **Setting Default Access Tier for a Storage Account**  
   - Navigate to **Azure Storage Account** → **Overview**.  
   - The **default access tier** is set to **Hot**. Click on it to **change to Cool**.  

2. **Changing Tier for a Specific Blob**  
   - Navigate to the **Storage Account** → **Container** → Select a **Blob** (e.g., `Site1/image.png`).  
   - Click on **Change Tier** → Select **Hot, Cool, Cold, or Archive**.  

3. **Archive Tier Availability**  
   - **Hot and Cool** can be set **at the Storage Account level**.  
   - **Cold and Archive** can **only be applied at the Blob (object) level**.  
