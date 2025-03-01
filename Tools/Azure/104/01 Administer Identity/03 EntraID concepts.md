### **Microsoft Entra ID Concepts**  

Microsoft Entra ID is built on several fundamental identity concepts. These concepts are essential for understanding how authentication and access control work within the Microsoft cloud ecosystem.  

- Microsoft Entra ID revolves around identities and accounts that help manage access to various Microsoft services. Below are the key concepts explained with examples.


### **1. Identity**  
An **identity** refers to any object that can be authenticated. This includes:  

- **Users**: Individual user accounts.  Employees, students, or any individual with login credentials
- **Groups**: Collections of users with shared access policies(common access permissions) 
- **Managed Identities**: Identities assigned to Azure services to access other resources securely.  A special identity for Azure services like Virtual Machines (VMs) or App Services, allowing them to access other resources without storing passwords
- **Service Principals**: Similar to on-premises **service accounts**, these are used to automate tasks and execute operations on behalf of a user or application. Used when an application or script needs to perform actions on behalf of a user
- Example:
    - A developer logs into Azure → This is a user identity
    - An Azure Virtual Machine automatically accesses a database → It uses a managed identity
    - A CI/CD pipeline deploys applications automatically → It uses a service principal

Managed identities and service principals are particularly useful for securing application workloads and enabling seamless access to Azure resources.  


### **2. Account**  
When **data attributes** (such as location, department, manager, and phone number) are associated with an identity, it becomes an **account**.  
- Example:
    - a user identity with associated attributes forms a **user account**, making it unique and distinguishable within the system.  
    - A user "John Doe" exists in Microsoft Entra ID. When his email, department, and phone number are added, it becomes a user account.


### **3. Microsoft Entra ID Account**  
An **account created within Microsoft Entra ID** or any **Microsoft cloud service** is referred to as a **Microsoft Entra ID Account**.  

These accounts can be classified into:  
- **Work or School Accounts**: Created by an organization for employees or students (e.g., `user@company.com`).
    - Example " If an employee at KodeKloud logs into their work email (user@kodekloud.com), it's a Work/School Account
- **Personal Microsoft Accounts**: Used for services like **Outlook, Xbox, Hotmail, and Microsoft Certification Exams**.  
    - If a person signs up for a Microsoft exam using a Hotmail account, it's a Personal Microsoft Account

Essentially, any account tied to **Microsoft cloud services** falls under this category.  

### **4. Microsoft Entra ID (Tenant/Directory)**  
A **Microsoft Entra ID Tenant** (also called a **Directory**) is a **dedicated instance of Microsoft Entra ID** that is created when an organization signs up for a **Microsoft cloud service subscription**.  

- **Tenant and Directory are interchangeable terms**.  
- All **Azure subscriptions** purchased by an organization are **mapped to a single tenant**.  
    - Every organization gets a separate tenant.
    - All subscriptions and resources are linked to that tenant.
    - example, when an **Azure account** is created, a **tenant (directory)** is automatically provisioned, and all **future services and users are associated with it**.  
    -  Example: When a company XYZ Ltd. signs up for Azure, a tenant (xyz.onmicrosoft.com) is created. If the company later buys Microsoft 365, it is also linked to this tenant.
    - Example : When `TechCor`p signs up for Azure, a Microsoft Entra ID tenant (directory) is automatically created for them.
        - Tenant Name: techcorp.onmicrosoft.com
        - This tenant stores all users, devices, and groups inside TechCorp's system.
        - Any new subscriptions (like adding Microsoft 365 later) will be tied to this same tenant.
