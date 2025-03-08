# **Session Persistence in Azure Load Balancer**  

Session persistence in Azure Load Balancer determines how **client requests are managed across multiple sessions**. The primary purpose of session persistence is to **ensure consistent routing of client requests** to backend servers, maintaining session integrity when required.  

Azure Load Balancer offers **three session persistence options**:  
1. **None (Default)** – Traffic is distributed using a five-tuple hash, without session affinity.  
2. **Client IP** – Uses a two-tuple hash to maintain session persistence based on the client's IP address.  
3. **Client IP and Protocol** – Uses a three-tuple hash to maintain persistence based on both client IP and protocol.  



## **1. None (Five-Tuple Hash - Default Setting)**  

### **Definition and Purpose**  
- When **no session persistence** is selected, Azure Load Balancer **distributes incoming traffic dynamically** based on a **five-tuple hash**.  
- The five-tuple hash includes:  
  1. **Source IP** (Client’s IP Address)  
  2. **Destination IP** (Backend Server’s IP)  
  3. **Source Port**  
  4. **Destination Port**  
  5. **Protocol (TCP/UDP)**  

### **How It Works**  
- Every time a request arrives, Azure Load Balancer **computes a hash** using these **five factors**.  
- The request is then **sent to a backend server** based on this hash value.  
- This process ensures **even load distribution** but does **not guarantee that the same client will be directed to the same backend instance** in future requests.  

### **Use Case**  
- **Best suited for stateless applications**, where each request can be handled independently.  
- Example: **REST APIs**, **static websites**, and **microservices** that do not rely on persistent user sessions.  



## **2. Client IP (Two-Tuple Hash)**  

### **Definition and Purpose**  
- In **Client IP session persistence**, Azure Load Balancer uses a **two-tuple hash** consisting of:  
  1. **Source IP (Client's IP Address)**  
  2. **Destination IP (Backend Server’s IP Address)**  

- All requests from the same **source IP (client)** will be sent to **the same backend server** as long as the backend instance remains healthy.  

### **How It Works**  
- When a client sends a request, Azure Load Balancer **records the client’s IP** and maps it to a backend instance.  
- Future requests from the same client **will always be directed to the same backend instance**.  
- If the assigned server fails, the Load Balancer redirects the traffic to another healthy server.  

### **Use Case**  
- **Recommended for stateful applications** that require user session consistency.  
- Example: **E-commerce shopping carts**, **banking applications**, or **web apps that store session data on the server**.  



## **3. Client IP and Protocol (Three-Tuple Hash)**  

### **Definition and Purpose**  
- **Client IP and Protocol session persistence** uses a **three-tuple hash**, consisting of:  
  1. **Source IP (Client's IP Address)**  
  2. **Destination IP (Backend Server’s IP Address)**  
  3. **Protocol (TCP/UDP)**  

- This ensures that a client's traffic is **sent to the same backend server, considering both IP and protocol type**.  

### **How It Works**  
- When a client initiates a request, Azure Load Balancer **tracks both the client’s IP and the protocol used**.  
- Future requests using the **same protocol** (e.g., HTTP or HTTPS) will be directed to **the same backend server**.  
- This is particularly useful when a **backend server hosts multiple services on different protocols**.  

### **Use Case**  
- **Useful when multiple services are running on the same VM** but require **session persistence per protocol**.  
- Example:  
  - A VM handles both **secure (HTTPS - TCP 443)** and **non-secure (HTTP - TCP 80)** traffic.  
  - The Load Balancer ensures that secure and non-secure sessions remain **separately mapped** to the same backend server.  



## **Choosing the Right Session Persistence Option**  

| Session Persistence Option | Hash Type | Key Features | Best For |
|---------------------------|-----------|-------------|----------|
| **None (Default)** | **Five-Tuple Hash** (Src IP, Dst IP, Src Port, Dst Port, Protocol) | Even traffic distribution, no session affinity | **Stateless apps, APIs, microservices** |
| **Client IP** | **Two-Tuple Hash** (Src IP, Dst IP) | Directs requests from the same client IP to the same backend | **E-commerce, banking apps, user sessions** |
| **Client IP and Protocol** | **Three-Tuple Hash** (Src IP, Dst IP, Protocol) | Maintains session persistence across services running different protocols | **Apps with multiple protocols per VM** |



## **Conclusion**  

Session persistence in Azure Load Balancer ensures **efficient routing of client requests** based on different hash mechanisms.  
- **None (Five-Tuple Hash)** – Ideal for **stateless applications** where session affinity is unnecessary.  
- **Client IP (Two-Tuple Hash)** – Suitable for **stateful applications** that require consistent backend mapping.  
- **Client IP and Protocol (Three-Tuple Hash)** – Used when **different services on the same VM** need **separate session management**.  

Selecting the **appropriate session persistence option** is **critical for optimizing performance**, ensuring **session consistency**, and maintaining **backend efficiency**.



### **Deploying and Configuring Azure Load Balancer**  

Azure Load Balancer is used to distribute **incoming traffic** across multiple virtual machines (VMs) in a backend pool. This ensures **high availability, fault tolerance, and efficient resource utilization**. The following steps outline the process of deploying and configuring an Azure Load Balancer using a PowerShell script.



## **1. Infrastructure Preparation**  

Before deploying the Load Balancer, the **infrastructure must be prepared**, including:  
- **Virtual Machines (VMs)** for the backend servers.  
- A **Jumpbox** (bastion host) for secure SSH access.  
- A **PowerShell script (`load balancer prep infra.ps1`)** to automate VM deployment and configuration.  

### **Steps to Deploy VMs and Configure Web Servers**  
1. **Execute the PowerShell script** to deploy VMs.  
2. The script:  
   - **Creates virtual machines** and assigns private IP addresses.  
   - **Installs a web server role** and **updates the web pages** on the VMs.  
3. Once execution is complete:  
   - The **Jumpbox is deployed** with a **public IP address** for SSH access.  
   - The **web servers have private IPs** and are **not exposed to the internet**.  

### **Verifying Web Server Configuration**  
1. SSH into the **Jumpbox**.  
2. Connect to a **web server using its private IP**.  
3. Execute a **curl command** to check if the web page responds correctly.  
4. Different servers return different **HTML color-coded responses** (e.g., **red, green, blue**) to differentiate responses.  


## **2. Deploying the Azure Load Balancer**  

Once the infrastructure is set up, an **Azure Load Balancer** is deployed to expose the web servers to the internet.  

### **Choosing the Load Balancer Type**  
- **Standard Load Balancer** (Recommended for production).  
- **Basic Load Balancer** (Only for development; not recommended for production).  
- A **Public Load Balancer** is used to handle external traffic.  

### **Steps to Deploy the Load Balancer**  
1. **Create a Load Balancer** in the same **Resource Group** as the VMs.  
2. Name the Load Balancer (e.g., `sclbweb01`).  
3. Select **Standard SKU** for production.  
4. Choose **Regional scope** (not Global Load Balancer).  



## **3. Configuring the Load Balancer**  

### **Step 1: Frontend IP Configuration**  
- A **Public IP Address (`sclbpip`)** is created for external access.  
- The frontend IP acts as the **entry point** for incoming traffic.  

### **Step 2: Backend Pool Configuration**  
- A **backend pool** is created to group the VMs handling the traffic.  
- The web servers (`webserver1`, `webserver2`, `webserver3`) are **added to the backend pool**.  

### **Step 3: Load Balancer Rules**  
- Load Balancer rules connect the **frontend IP** to the **backend pool**.  
- A **Load Balancing Rule** is created:  
  - **Name:** `sclb_lb_http`  
  - **Frontend IP:** The public IP (`sclbpip`).  
  - **Backend Pool:** The pool containing the three VMs.  
  - **Protocol:** **TCP**  
  - **Frontend Port:** **80**  
  - **Backend Port:** **80**  

### **Step 4: Health Probes**  
- A **Health Probe** is created to monitor backend server health:  
  - **Name:** `sclb_http_probe`  
  - **Protocol:** **HTTP**  
  - **Port:** **80**  
  - **Interval:** **5 seconds**  
  - **Failure Detection:** If a VM fails to respond, it is **marked unhealthy**, and the Load Balancer stops sending traffic to it.  

### **Step 5: Session Persistence Configuration**  
- The default **Five-Tuple Hash** is used for session persistence.  
- This means that the same client **may or may not be directed to the same backend instance**, depending on the tuple values (source IP, destination IP, source port, destination port, protocol).  

### **Step 6: Additional Rules**  
- **Inbound NAT rules** are **not** required since SSH access is managed through the Jumpbox.  
- **Outbound rules** are not configured as this setup only handles inbound HTTP traffic.  



## **4. Deploying and Validating the Load Balancer**  

### **Final Deployment Steps**  
1. **Review the configuration and deploy the Load Balancer.**  
2. Once the deployment is complete, navigate to **Load Balancer → Backend Pool** to verify that the three VMs are correctly associated.  
3. Check the **Frontend IP configuration** to retrieve the **public IP address** assigned to the Load Balancer.  

### **Testing the Load Balancer**  
1. Copy the **public IP address** of the Load Balancer.  
2. Open a **web browser** and enter the **public IP**.  
3. The page should display **responses in different colors** (blue, red, green) from different backend servers.  
4. Refreshing the page multiple times may result in:  
   - Different servers responding, based on the **five-tuple hash** mechanism.  
   - The same response appearing repeatedly **unless one of the tuple values changes**.  



## **Conclusion**  

The **Azure Load Balancer** is successfully configured to distribute **HTTP traffic (port 80) across three backend VMs**. The key takeaways include:  
1. **Infrastructure setup** with Virtual Machines and a Jumpbox.  
2. **Creating a Standard Public Load Balancer** for external access.  
3. **Configuring the Frontend IP, Backend Pool, and Load Balancing Rules**.  
4. **Setting up a Health Probe** to monitor VM health.  
5. **Using the Five-Tuple Hash for session persistence**, leading to **dynamic request routing**.  

The deployment ensures **high availability and redundancy**, allowing efficient **traffic distribution** across multiple backend servers.