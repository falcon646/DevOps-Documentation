# **Designing a Production-Grade AKS Cluster using Azure CLI**  

## **Introduction**  
In this section, the focus is on designing a **production-grade Azure Kubernetes Service (AKS) cluster** using the **Azure CLI**. While the **Azure Portal management console** can be used to create and manage AKS clusters, it is **not recommended for production environments** due to its manual nature and lack of automation. Instead, **Azure CLI** provides a more structured and automated approach.  

### **What will be covered?**  
This section is divided into **three sub-sections**, covering the following topics in depth:  

1. **Creating an AKS Cluster using Azure CLI**  
2. **Understanding Node Pools (System, User, and Virtual Nodes)**  
3. **Deploying Applications using Node Selectors**  

The final goal is to deploy:  
- **Java applications** on **Linux user node pools**  
- **.NET applications** on **Windows user node pools**  
- **Simple web applications** on **virtual nodes**  

Additionally, applications can also be scheduled to **system node pools** if required.  

---  

## **Overview of the Azure AKS Cluster Architecture**  

An **AKS cluster** consists of several core components, categorized into:  
1. **Basics**  
2. **Integrations**  
3. **Node Pools**  
4. **Authentication**  
5. **Networking**  

Each category has several **decision points** that impact the cluster's design.  

---

## **1. Basics**  

The key decisions to make when designing the **basics** of an AKS cluster include:  

### **1.1 Selecting a Region**  
- The **region** where the AKS cluster will be deployed.  
- **Performance, availability, and compliance** depend on the selected region.  

### **1.2 Choosing the Kubernetes Version**  
- The version of **Kubernetes** to be used in the AKS cluster.  
- Azure regularly updates Kubernetes versions, so it is important to select a **stable, supported version**.  

### **1.3 Availability Zones**  
- Azure provides up to **three availability zones** for **high availability**.  
- The decision is whether to deploy the **system node pool** in **one, two, or three availability zones**.  

---

## **2. Node Pools**  

In AKS, there are **three types of node pools**:  

1. **System Node Pools**  
2. **User Node Pools**  
3. **Virtual Nodes**  

### **2.1 System Node Pool**  
- By default, an AKS cluster creates a **System Node Pool** with **one or more worker nodes**.  
- The **Azure AKS control plane** is **free**, but system node pools **incur a cost**.  
- This node pool runs **critical system components** like:  
  - **kube-system workloads**  
  - **CoreDNS**  
  - **Azure Container Storage (ACS) Connector**  
  - **Other Kubernetes system services**  

### **2.2 User Node Pools**  
- **User node pools** are created to run **application workloads**.  
- Applications should not run on **system node pools** but on dedicated **user node pools**.  
- There are **two types**:  
  - **Linux user node pools** (for Linux-based applications)  
  - **Windows user node pools** (for Windows-based applications)  

### **2.3 Virtual Nodes**  
- **Virtual nodes** provide **serverless infrastructure** using **Azure Container Instances (ACI)**.  
- This allows **on-demand scaling** without provisioning additional VM-based worker nodes.  
- **Only Linux workloads** are supported in virtual nodes.  

---

## **3. Authentication & Authorization**  

### **3.1 Managed Identity**  
- **System-Assigned Managed Identity (Recommended)**  
  - Automatically assigned by Azure and tied to the cluster lifecycle.  
  - Best practice for authentication.  
- **Service Principal** (alternative)  
  - Manually created and requires lifecycle management.  

### **3.2 Kubernetes RBAC (Role-Based Access Control)**  
- **Enabled by default** in AKS for managing permissions at the Kubernetes resource level.  
- Recommended to **keep it enabled** for production environments.  

### **3.3 Azure AD Integration**  
- **Optional but recommended** for enterprise-grade security.  
- Provides **centralized identity management**.  
- **Important Note:**  
  - Once **Azure AD integration is enabled**, it **cannot be disabled**.  
  - This is a **critical decision point** before enabling it.  

---

## **4. Networking**  

### **4.1 Azure CNI vs. Kubenet**  
- **Azure CNI (Recommended)**  
  - Provides **better network performance and security**.  
  - Fully integrates with **Azure Virtual Networks (VNet)**.  
  - Required for **virtual nodes**.  
- **Kubenet (Not Recommended for Production)**  
  - Simpler but **does not provide full VNet integration**.  
  - Less scalable and secure.  

### **4.2 Load Balancing & Outbound Traffic**  
- **Standard Azure Load Balancer** is the default option.  
- **Outbound IPs:**  
  - Important for handling **external connectivity**.  
  - **Each public IP supports 65,535 connections**.  
  - For heavy outbound traffic, multiple **public IPs** should be assigned.  

### **4.3 Public vs. Private AKS Cluster**  
- **Public Cluster:**  
  - Exposes the **Kubernetes API Server** over the internet.  
  - Can restrict API access using **specific IP allowlists**.  
- **Private Cluster (Recommended for Security):**  
  - API Server is accessible **only within a private VNet**.  
  - Requires a **jumpbox** or VPN for access.  

---

## **5. Integrations (Add-ons)**  

### **5.1 Azure Container Registry (ACR) Integration**  
- Docker images can be pulled from:  
  - **Docker Hub** (public)  
  - **Azure Container Registry (ACR) (Recommended for Azure AKS)**  
  - **AWS Elastic Container Registry (ECR)** (for multi-cloud scenarios)  
- **Best Practice:** Use **Azure Container Registry** with **Managed Identity Authentication** for security.  

### **5.2 Azure Monitor & Logging**  
- **By default, Azure Monitor is enabled when creating AKS from the portal.**  
- **With Azure CLI, it must be explicitly enabled.**  
- Provides **monitoring, logging, and metrics** for the AKS cluster.  

### **5.3 Azure Policy for Kubernetes**  
- Provides **fine-grained security policies** for **pod-to-pod communication**.  
- Mostly used for **high-security environments (e.g., banking and finance).**  
- Not required during cluster creation but can be **enabled later**.  

---

## **Final Architecture of the AKS Cluster**  

A well-designed **production-grade AKS cluster** includes:  
- **System Node Pools** for Kubernetes system workloads  
- **User Node Pools** for application workloads (**Linux & Windows**)  
- **Virtual Nodes** for on-demand scalability  
- **Authentication via System-Assigned Managed Identity**  
- **Role-Based Access Control (RBAC) enabled**  
- **Networking using Azure CNI with standard Load Balancer**  
- **Integration with Azure Container Registry**  
- **Azure Monitor enabled for cluster observability**  


