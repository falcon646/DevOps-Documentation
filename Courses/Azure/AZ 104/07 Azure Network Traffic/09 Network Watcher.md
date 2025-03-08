# **Azure Network Watcher - Monitoring & Diagnostic Tools**  

Azure **Network Watcher** is a **suite of tools** designed to **monitor, diagnose, and analyze network performance** in an **Azure environment**. These tools help in troubleshooting **network connectivity, routing, packet flow, and security** issues.  


## **Overview of Network Watcher Tools**  

| **Feature**          | **Purpose** |
|----------------------|------------|
| **IP Flow Verify**   | Checks if packets are **allowed or denied** based on **NSG rules**. |
| **Next Hop**        | Determines the **next routing hop** for packets in an **Azure Virtual Network**. |
| **VPN Diagnostics**  | Diagnoses **Azure VPN Gateway** and **connection issues** with on-premises networks. |
| **NSG Flow Logs**    | Captures **ingress and egress IP traffic** through an **NSG**. |
| **Connection Troubleshoot** | Analyzes **connectivity between two endpoints**, including **latency and hops**. |
| **Topology**        | Provides a **visual representation of the Virtual Network resources**. |


### **1. IP Flow Verify**  
- Used to **validate network security rules** in **NSGs (Network Security Groups)**.  
- Helps determine whether **traffic is allowed or denied** to/from a **virtual machine**.  
- Useful for diagnosing **connectivity issues** related to **firewall rules**.  
- Example Use Case: If a VM **cannot communicate** with another service, this tool can **identify blocked traffic** in NSG rules.  



### **2. Next Hop**  
- Identifies the **next routing hop** for a packet within an **Azure Virtual Network**.  
- Helps **troubleshoot routing issues**, especially when using **custom route tables** or **firewalls**.  
- Example Use Case: If packets are supposed to go through a **firewall**, but traffic is **not reaching** it, Next Hop can help confirm if the packet is following the correct **routing path**.  



### **3. VPN Diagnostics**  
- **Monitors and troubleshoots VPN Gateway connectivity** to **on-premises networks**.  
- Generates **diagnostic reports** stored in an **Azure Storage Account** for analysis.  
- Helps identify **connection failures** in **hybrid cloud setups**.  
- Example Use Case: If a **VPN connection is failing**, this tool helps find the **root cause** (e.g., incorrect gateway configuration, certificate issues, or network latency).  



### **4. NSG Flow Logs**  
- Captures **real-time network traffic data** passing through a **Network Security Group (NSG)**.  
- Logs are **stored in an Azure Storage Account** for auditing and **security analysis**.  
- Helps **identify unusual network activity**, security risks, and **troubleshoot connectivity issues**.  
- Example Use Case: If an **unexpected amount of traffic** is coming from an external IP, **NSG Flow Logs** help **track the source** and analyze security risks.  



### **5. Connection Troubleshoot**  
- Provides **detailed analysis** of **connectivity between two endpoints**.  
- Tracks **latency, network hops, and packet loss** along the transmission path.  
- Helps **diagnose connectivity failures** between **Azure resources**.  
- Example Use Case: If an **application is experiencing high latency**, this tool can analyze whether the issue is caused by **network delays or routing problems**.  



### **6. Topology**  
- Generates a **graphical representation** of **network resources** in a **Virtual Network**.  
- Helps **visualize dependencies** and **troubleshoot misconfigurations**.  
- Example Use Case: A **network administrator** can use the **topology map** to **understand the network architecture** and identify **incorrectly connected resources**.  



## **Summary**  

Azure **Network Watcher** provides **essential tools** for **network monitoring and troubleshooting**, including:  

- **IP Flow Verify** → Checks **NSG rules** to see if traffic is allowed/denied.  
- **Next Hop** → Identifies the **next routing hop** for packets.  
- **VPN Diagnostics** → Diagnoses **VPN Gateway** and **hybrid network connectivity** issues.  
- **NSG Flow Logs** → Captures **traffic logs** for **security auditing**.  
- **Connection Troubleshoot** → Analyzes **connectivity issues** between **Azure resources**.  
- **Topology** → **Visualizes the Virtual Network architecture** for easier analysis.  

Each of these tools is **critical for maintaining network security, performance, and reliability** in Azure environments.


# **Using Azure Network Watcher in the Azure Portal**  

Azure **Network Watcher** provides a set of tools to **monitor and troubleshoot network issues** in an Azure environment. The following tools are available within **Azure Portal**, allowing users to analyze traffic flow, diagnose security rules, verify routing, and capture network packets.  



## **Accessing Network Watcher in Azure Portal**  
- In **Azure Portal**, search for **Network Watcher** to access its features.  
- Select a **region**, then choose specific **Virtual Machines (VMs), subnets, and network components** for diagnostics.  




### **2. IP Flow Verify**  
- **Purpose**: Checks if traffic is **allowed or denied** based on **Network Security Group (NSG) rules**.  
- **Steps in Azure Portal**:  
  1. Select a **Virtual Machine (VM)** (e.g., `Gembox VM`).  
  2. Choose the **network interface** of the VM.  
  3. Set **Protocol (TCP/UDP), Direction (Inbound/Outbound), Local IP, Remote IP, and Port Number**.  
  4. Run the test to determine **if traffic is allowed or blocked**.  
- **Example Scenario**:  
  - **Port 3389 (RDP) blocked** due to "Deny All Inbound" rule.  
  - **Port 22 (SSH) allowed** due to an existing security rule.  



### **3. NSG Diagnostics**  
- **Purpose**: Collects **diagnostic logs** from **NSGs (Network Security Groups)**.  
- **Use Case**:  
  - Helps analyze **traffic patterns** and security rule effectiveness.  
  - Logs are **stored in an Azure Storage Account** for further inspection.  



### **4. Next Hop**  
- **Purpose**: Identifies the **next routing hop** for network traffic within an **Azure Virtual Network**.  
- **Steps in Azure Portal**:  
  1. Select a **source VM**.  
  2. Enter a **destination IP address**.  
  3. Run the diagnostic to determine the **next hop**.  
- **Example Scenarios**:  
  - **Traffic between VMs in the same VNet** → Next hop = **VNet Local**.  
  - **Traffic to the Internet** → Next hop = **Internet**.  
  - **Traffic routed through a firewall** → Next hop = **Virtual Appliance (UDR applied)**.  



### **5. Effective Security Rules**  
- **Purpose**: Analyzes the **effective NSG rules** applied at both the **subnet level and NIC level**.  
- **Use Case**:  
  - Helps troubleshoot **conflicting NSG rules** that may be blocking required traffic.  



### **6. VPN Troubleshoot**  
- **Purpose**: Diagnoses **Azure VPN Gateway** and **VPN connection issues**.  
- **Features**:  
  - **Bandwidth analysis**, **packet loss detection**, and **connectivity failure troubleshooting**.  
  - Stores **VPN diagnostic logs** in an **Azure Storage Account** for review.  



### **7. Packet Capture**  
- **Purpose**: Captures **real-time network traffic** for debugging and security analysis.  
- **Steps in Azure Portal**:  
  1. Click **Add Packet Capture**.  
  2. Select a **Virtual Machine (VM)**.  
  3. Choose the **storage location** (Azure Storage Account or within the VM).  
  4. Set **filters** (e.g., only capture traffic on **port 53 for DNS traffic**).  
  5. Start the packet capture.  
- **Use Case**:  
  - Eliminates the need for **Wireshark or TCPDump** by capturing packets directly in Azure.  
  - Captured data is **saved in a `.pcap` file** for analysis in **Wireshark**.  


### **8. Connection Troubleshoot**  
- **Purpose**: Tests **connectivity between two endpoints**, checking:  
  - **Round Trip Time (RTT)**.  
  - **NSG inbound and outbound rules**.  
  - **Port accessibility**.  
  - **Next hop and route details**.  
- **Steps in Azure Portal**:  
  1. Select a **source Virtual Machine (e.g., `Gembox` VM)**.  
  2. Choose a **destination (another VM or external IP/FQDN)**.  
  3. Select **protocol (TCP/UDP)** and **destination port**.  
  4. Run the diagnostic and analyze the results.  
- **Example Use Case**:  
  - Checking connectivity between **Gembox VM** and **Blue VM** on **port 22 (SSH)**.  
  - If connection fails, the tool provides insights on **NSG rules, network latency, and routing issues**.  



### **9. Topology**  
- **Purpose**: **Visualizes the network architecture** of a **Virtual Network (VNet)**.  
- **Features**:  
  - Shows **subnets, NSGs, Virtual Machines, NICs, and their relationships**.  
  - Expands subnet views to display **connected components**.  
- **Example Use Case**:  
  - Selecting **Color VNet** displays:  
    - **Gateway NSG**.  
    - **Blue Subnet, Red Subnet**.  
    - **Connected Virtual Machines and Network Interfaces**.  



## **Summary**  

| **Tool**                | **Purpose** | **Example Scenario** |
|-------------------------|------------|----------------------|
| **IP Flow Verify**       | Checks if traffic is **allowed/denied** by NSGs. | RDP port 3389 blocked due to "Deny All Inbound". |
| **NSG Diagnostics**      | Collects logs from NSGs for **security analysis**. | Reviewing traffic patterns in an NSG. |
| **Next Hop**            | Identifies the **next routing hop** for a packet. | Ensuring packets reach a firewall as expected. |
| **Effective Security Rules** | Analyzes **combined NSG rules** at the subnet and NIC level. | Resolving conflicting NSG rules blocking traffic. |
| **VPN Troubleshoot**     | Diagnoses **VPN Gateway and connection issues**. | Checking VPN bandwidth and identifying failed packets. |
| **Packet Capture**       | Captures **real-time network traffic** for debugging. | Capturing DNS traffic on **port 53** for analysis. |
| **Connection Troubleshoot** | Tests **end-to-end connectivity** between two endpoints. | Verifying SSH connectivity between two VMs. |
| **Topology**            | Visualizes **Virtual Network architecture**. | Viewing **subnets, VMs, NICs, and routing paths**. |

These tools **enhance network visibility and troubleshooting**, allowing administrators to **quickly diagnose and resolve networking issues** within Azure.