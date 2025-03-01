### **Introduction to Terraform Language Basics**  

In the previous section, Terraform command basics were covered. The focus now shifts to **Terraform language basics**, which includes understanding its syntax, variables, and state management.  

## **Overview of This Section**  
This section covers:  
✔ **Terraform Syntax** – Understanding structure and syntax rules.  
✔ **Resources & Blocks** – Defining infrastructure components.  
✔ **Arguments & Identifiers** – Configuring Terraform code.  
✔ **Variables** – Understanding **input variables, output values, and local variables**.  
✔ **Commenting Code** – How to add comments in Terraform files.  
✔ **State Management** – Migrating **local state to remote storage** (Azure Storage Container).  

---

## **Why Learn Terraform Language Basics?**  
- Terraform uses a **domain-specific language (HCL)** to define infrastructure.  
- Understanding **blocks, arguments, and resources** is essential for writing efficient Terraform code.  
- Managing **input variables and output values** improves modularity and reusability.  
- **Remote state storage** is crucial for **team collaboration** and infrastructure consistency.  

---

## **Transitioning to Remote State**  
- Initially, Terraform stores its state **locally** in a `.tfstate` file.  
- For **collaborative environments**, it is recommended to store Terraform state in **remote storage**, such as an **Azure Storage Container**.  
- From this point forward, all Terraform configurations will use **remote state storage** instead of local state.  

