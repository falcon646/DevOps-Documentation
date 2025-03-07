#### **Step-03: NIC and NSG**
Now, we are going to create the network interface (NIC) for thwe web VM. In addition, we will associate a Network Security Group (NSG) with this NIC.  

#### **Why do we need multiple Network Security Groups (NSG) ?**
NSGs provide security at different levels or basically to provide layered security
- **First-level security**: Subnet-level NSG (applied to all VMs in the subnet)
    - exaple : At the **web subnet level**, there is a **web NSG**, which acts as the **first level of security** for all the vm in the web subnet
- **Second-level security**: VM-specific NSG (applied only to the respective VM).
The second-level NSG is optional and depends on security needs.
    - Example : an **NSG can be created and associated with the a specific VM’s NIC**, providing a **second level of security** for that specific vm.  
    - This additional NSG is **optional**, and enabling it depends on security requirements. In this demo, we will enable it for demonstration purposes and review its configurations. After that, we will disable it.  
    - With this NIC/VM level NSG, global ports can be opened while also restricting specific ports for the respective VM. 
    - Within the web-tier subnet, there are **high-security servers** and **low-security servers**.  
        - **For low-security servers**, an NSG may not be necessary.  
        - **For high-security servers**, where only specific ports need to be open, assigning a dedicated NSG to the VM ensures tighter control.  

**Summary :** The **web-tier NSG** applies **rules at the subnet level**, affecting all servers in the subnet. The **VM-specific NSG** applies rules at the individual VM level, allowing for more granular control.  


#### c10-03-web-linuxvm-network-interface.tf
The following attributes are defined for the network interface:  

```hcl
name                = "${local.resource_name_prefix}-web-linuxvm-nic"
location            = azurerm_resource_group.myrg.location
resource_group_name = azurerm_resource_group.myrg.name
```
**IP Configuration Block**  
The **`ip_configuration`** block is an important part of the **network interface**.  
- The **IP configuration** block defines the **private and public IP settings** for the NIC.  
- Azure **allows multiple IP configurations** within a single NIC. Each configuration represents an **IP address**.  
- **Key Components of `ip_configuration`**  
    - **Configuration Name** : A meaningful name is given: `"web-linuxvm-ip-1"`.  
    - **Subnet Association**   The network interface must be linked to a **subnet** to obtain a **private IP address**.  
    - The subnet ID is retrieved from the **subnet resource**:  
     ```hcl
     subnet_id = azurerm_subnet.websubnet.id
     ```
    - **Private IP Address Allocation**  
        - Azure supports two types:  
        - **Dynamic:** Azure automatically assigns an IP address.  
        - **Static:** A specific IP address must be manually assigned.  
        - Here, **dynamic allocation** is used:  
            ```hcl
            private_ip_address_allocation = "Dynamic"
            ```
    - **Public IP Association**  
        - The NIC is linked to the **public IP address** created earlier.  
        - The **public IP reference** is assigned using:  
            ```hcl
            public_ip_address_id = azurerm_public_ip.web_linuxvm_publicip.id
            ```
        - This ensures that the VM gets a **publicly accessible IP**.  

```hcl
# Resource: Create Network Interface
resource "azurerm_network_interface" "web_linuxvm_nic" {
  name                = "${local.resource_name_prefix}-web-linuxvm-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "web-linuxvm-ip-1"
    subnet_id                     = azurerm_subnet.websubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.web_linuxvm_publicip.id 
  }
}
```

**`ip_configuration` in Azure Network Interfaces**  

In **Azure**, a **network interface (NIC)** connects a **virtual machine (VM)** to a **virtual network (VNet)**. The `ip_configuration` block defines how the NIC assigns **IP addresses** and interacts with **subnets** and **public IPs**.  

Every NIC must have at least one `ip_configuration` to function properly. This configuration ensures that the VM can communicate within Azure's **private network** or with the **internet**, depending on the assigned IP settings.  


The `ip_configuration` block is essential for:  

1. **Assigning Private IP Addresses**  
   - The NIC gets an **internal IP address** from an associated **subnet** in the **virtual network**.  
   - This allows the VM to communicate **within the VNet** without needing a public IP.  
2. **Associating Public IP Addresses** (Optional)  
   - If a VM needs internet access, a **public IP address** can be attached.  
   - The `ip_configuration` block links the NIC to the **public IP resource**.  
3. **Supporting Multiple IP Addresses**  
   - A single NIC can have **multiple IP configurations**, meaning a VM can have **multiple private and public IPs**.  
   - This is useful for **load balancing**, **multi-homed network setups**, or **hosting multiple services** on different IPs.  
4. **Controlling IP Allocation Mode**  
   - Determines whether the **private IP** is **dynamically** assigned by Azure or **statically** set by the user.  
   - `Dynamic`: Azure automatically assigns an available IP from the subnet range.  
   - `Static`: A specific IP is manually assigned and reserved.  

**How is `ip_configuration` Used in Azure?**  
The `ip_configuration` block is part of the **network interface settings** and is configured when creating or modifying a NIC.  

- When a VM is created, its NIC is assigned an `ip_configuration` that includes:  
  - **A private IP from the subnet** (mandatory).  
  - **A public IP** (optional).  
  - **The method of IP allocation** (dynamic/static).  

- The configuration can be viewed or modified through:  
  - **Azure Portal** (VM → Networking → Network Interface).  
  - **Azure CLI** (`az network nic ip-config create`).  
  - **Azure PowerShell** (`New-AzNetworkInterface`).  
  - **Azure Resource Manager (ARM) Templates**.  

**Why is `ip_configuration` Necessary?**  

Without `ip_configuration`, the **network interface** cannot function, and the VM:  

- **Cannot communicate within the virtual network** (if no private IP is assigned).  
- **Cannot be accessed from the internet** (if no public IP is assigned).  
- **Cannot have network-level security rules** (which rely on IP settings).  

Additionally, `ip_configuration` enables:  
- **Load balancer integration** for distributing traffic.  
- **Multiple NICs with different subnets/IPs** for complex networking setups.  
- **Fine-grained control over IP assignments** to meet specific networking requirements.  


**Example Scenario**  
A company deploys an **Azure VM** that hosts a web application. They configure the VM’s **NIC** as follows:  

| Setting                | Value | Purpose |
|------------------------|--------|----------------------------|
| **Private IP**         | `10.0.0.5` | Internal communication |
| **Private IP Mode**    | `Static` | Fixed IP for DNS settings |
| **Public IP**          | `40.80.90.100` | External access to the web app |
| **Subnet**            | `web-subnet` | Belongs to a secure web tier |
| **Public IP Mode**    | `Dynamic` | IP assigned at runtime |

This setup ensures:  
- The VM can **communicate with backend services** via the private IP.  
- The web application is **accessible over the internet** through the public IP.  
- The **private IP remains fixed**, avoiding potential disruptions.  



