### **Configuring User Accounts in Microsoft Entra ID**  

User accounts serve as the **foundation of identity and access management** within Microsoft Entra ID. These accounts are more than just credentials—they function as **digital identities** that provide secure access to resources, applications, and services within an organization.  

- User accounts in Microsoft Entra ID are like digital passports that allow people to access work-related resources such as emails, files, and applications securely. These accounts ensure that only the right people can access specific services.

- Just like in a company, different employees have different roles and access levels, Microsoft Entra ID categorizes user accounts into different types based on how they are managed and where they come from.

### **Managing User Accounts**  
- Every user must have an account to **authenticate and access** resources securely.  
- User accounts can be **customized** with attributes such as **address, department, and role**, enhancing communication and workflow efficiency.  
- Administrators can manage user accounts centrally from the **Microsoft Entra ID portal** under **Users → All Users**.  
- **Bulk operations** streamline large-scale management tasks, including **account creation, invitations, and deletions**, which are essential for onboarding and offboarding users efficiently.  


### **Types of User Accounts in Microsoft Entra ID**  

#### **1. Cloud Identities (Standalone Accounts in the Cloud)**  
These accounts exist **only in Microsoft Entra ID**, with **no connection to an on-premises Active Directory**.  
- Ideal for **cloud-first organizations**, providing **global accessibility and simplified management**.  
- Users can belong to the **organization’s Entra ID** or an **external Entra ID** from another organization.
- These are users created and managed only in Microsoft Entra ID without any connection to a physical office or on-premises system.
    - Example: Imagine a company that operates 100% online with no physical offices. They create and manage employee accounts directly in Microsoft Entra ID. These users can log in from anywhere and use cloud services like Microsoft 365 and Teams.
    - Real-World Scenario:
        - A fully remote software company hires a new employee. The IT team creates a Microsoft Entra ID account for them, granting access to company emails, Teams, and SharePoint.
        - The employee logs in from their home laptop and accesses everything securely.


#### **2. Guest Accounts (External Users Invited  for Collaboration)**  
Created for users **outside the organization**, such as **partners, contractors, or vendors** to work with an organization without becoming a full-time user..  
- Provides controlled access to **specific resources** without adding users to the internal directory.  
- **Examples of guest accounts include:**  
  - **Microsoft accounts (Live, Outlook, Hotmail, etc.)**  
  - **Gmail or other non-Microsoft accounts**  
  - **Users from another organization with their own Microsoft Entra ID**  
- **Distinction:**  
  - If a user belongs to another **Microsoft Entra ID tenant**, they are considered a **Cloud Identity**.  
  - If the user does not have an Entra ID and is using a personal email (e.g., Gmail), they are considered a **Guest Account**.  
    - Example: A company is working on a project with a freelancer. Instead of creating a full employee account, they send an invitation to the freelancer's personal Gmail account, allowing them limited access to necessary resources.
    - Example: a law firm is collaborating with an external auditor. Instead of giving the auditor a company account, they invite them as a guest user using their personal email. The auditor can access specific documents on SharePoint but cannot access internal HR or finance systems.



#### **3. Directory Synchronized Users (Hybrid Identities)**  
- These accounts are **synchronized from an on-premises Active Directory** using **Microsoft Entra ID Connect** (formerly Azure AD Connect).  
- Enables a **unified identity** across both **on-premises and cloud environments**.  
- Ensures **seamless authentication** and **simplifies access management** for hybrid environments.
- These are users who already exist in an on-premises (local office) Active Directory system and are synchronized to Microsoft Entra ID. This allows users to log in with the same username and password both in the office and on cloud applications.
    - Example: A large bank has offices worldwide with thousands of employees. Instead of manually creating accounts in the cloud, they sync their existing Active Directory accounts to Entra ID. This ensures employees use the same login credentials for both on-premises and cloud-based applications.





#### **Adding Users in Microsoft Entra ID**  

To add users, the administrator logs into the **Azure Portal**, navigates to **Microsoft Entra ID > Users**, and can perform various user management tasks, such as:  
✅ Creating new users  
✅ Inviting external users  
✅ Modifying user properties  
✅ Deleting and restoring users  

- **1️⃣ Creating a Cloud Identity (Full Employee Account in the Organization)**  
  - A **cloud identity** is a user account that exists **only in Microsoft Entra ID** and is managed entirely in the cloud.  
  - **Example:**  
    - A company hires a new remote employee, Chris Welch.  
      - The IT admin **creates a cloud identity for Chris** in Microsoft Entra ID.  
      - Chris gets a **username and password** to log into company services like Microsoft 365, Teams, and SharePoint.  
      - The account has the company’s domain, e.g., **chris.welch@company.onmicrosoft.com**.  
  - **How to create?**  
      1. Click **New User** in the Azure Portal.  
      2. Enter user details (name, email, password).  
      3. Assign roles and permissions (optional).  
      4. Click **Create**.  

- **2️⃣ Inviting a Guest User (External Contractor or Partner)**  
  - A **guest account** is for external users (partners, freelancers, vendors) who need **temporary access** to company resources.  
  - **Example:**  
    - The company works with an **external marketing consultant** with an Outlook email.  
      - The admin **invites the consultant’s Outlook or Gmail account** as a guest user.  
      - The consultant receives an email invitation and **logs in using their existing credentials** (without creating a new account).  
  - **How to invite?**  
    1. Click **New User** > **Invite External User**.  
    2. Enter the external user’s email (e.g., **consultant@gmail.com**).  
    3. Click **Send Invitation**.  
    4. The guest user receives an invite and logs in.  

- **Key Difference:**  
  - If the guest is from **another company using Entra ID**, they are still a **cloud identity** but considered a **guest** in your organization.  
  - If the guest is using a **Gmail or Outlook account**, they will be recognized as a **Microsoft Account Identity**.  

- **3️⃣ Directory Synchronized Users (Office Employees with On-Premises Active Directory)**  
  - These are users whose accounts **exist in an on-premises (local office) Active Directory** and are **synced to Entra ID** using **Microsoft Entra Connect**.  
    - **Example:**  
      - A bank with **thousands of employees** has been using a **local Active Directory (AD)** for years.  
      - Instead of creating new cloud identities, the IT team **syncs their on-premises AD accounts** to Entra ID.  
      - Employees **use the same username and password** at the office and in cloud apps.  
      - If an employee **leaves the company**, disabling their AD account automatically disables cloud access.  
  - **How to check synchronized users?**  
    1. Apply the filter **On-Premises Sync Enabled: Yes** in the user list.  
    2. The system displays users **synced from the company’s local directory**.  


The **User Table in Azure Portal** provides information about user identities, their type (Member or Guest), and how they authenticate. Let's analyze the table based on the provided entries.

---

## **Understanding the Columns**  

### **1️⃣ userPrincipalName**  
- Represents the **unique username (email-like format)** assigned to the user.  
- It is used for authentication within **Microsoft Entra ID**.  

### **2️⃣ User Type**  
- **Member** → The user is **part of the organization** and has a cloud identity within this Entra ID tenant.  
- **Guest** → The user is **external** and has been **invited** from outside the organization.  

### **3️⃣ Identities**  
- Describes **where the user's authentication comes from**:
  - **External AD** → The user is authenticated from a **different Entra ID (Azure AD) tenant**.
  - **Microsoft Account** → The user logs in using a **personal Microsoft account (e.g., Outlook, Hotmail, Xbox, etc.)**.
  - **companyname.onmicrosoft.com** → The user belongs to another Entra ID tenant but still authenticates via Entra ID.

### Understanding the User Table and the Realtion to Identities and User type


| **userPrincipalName** | **User Type** | **Identities** | **Interpretation** |  
|----------------------|-------------|-------------|-----------------|  
| **xxx** | **Member** | **External AD** | The user is a **full member** of the organization but their authentication is handled by **another Entra ID tenant**. This means the user was added from another Microsoft tenant and given **membership access** rather than guest access. |  
| **yyy** | **Guest** | **Microsoft Account** | The user is an **external guest** who logs in using a **personal Microsoft account (Outlook/Hotmail/Xbox account)**. This is common when inviting freelancers or consultants who don’t have an Entra ID. |  
| **zzz** | **Guest** | **companyname.onmicrosoft.com** | The user is an **external guest** from **another company that uses Entra ID**. Even though they are a **guest in this tenant**, their authentication is managed by their **home tenant (companyname.onmicrosoft.com)**. |


- **Member + External AD**
  - **Example:** A company has a **multi-tenant setup**, and a user from another Entra ID tenant is **given full membership access** in this tenant. 
    - 🔹 **Inference:**   
      - This user **logs in with their external Entra ID account**, but they are treated as a **member** within this organization.
      - This is common in **mergers, partnerships, or multi-tenant organizations**.
- **Guest + Microsoft Account**
  - **Example:** A company invites a **freelancer using an Outlook account** to collaborate in Teams.  
  - **Inference:**  
    - This user does **not belong to any Entra ID**; they log in with a **Microsoft personal account**.  
    - Azure recognizes that it is a Microsoft account but treats it as a **guest**.

- **Guest + companyname.onmicrosoft.com**
  - **Example:** A vendor from **XYZ Corp (which uses Entra ID)** is invited to collaborate.  
  - **Inference:**  
    - This user is an **external guest** in this tenant but logs in using their **own organization’s Entra ID**.  
    - Their home organization still manages their identity (passwords, MFA, security policies), but they can access resources here.  
    - This is common in **B2B collaborations**.

- **Guest + tenantname.onmicrosoft.com**
  - If the company name in identity (companyname.onmicrosoft.com) is the same as the current tenant’s domain, then it means that:
    - The user should be a Member, not a Guest, because their identity is from the same Entra ID tenant.
    - If the user is still marked as a Guest, it indicates that they were invited instead of directly created as a member.
    - Possible Reasons for This Scenario:
      - The user was initially an external guest (before the organization fully onboarded them).
      - The user was invited from another tenant before the company migrated to a single Entra ID tenant.
      - The admin manually changed the user type from Member to Guest for specific access restrictions.