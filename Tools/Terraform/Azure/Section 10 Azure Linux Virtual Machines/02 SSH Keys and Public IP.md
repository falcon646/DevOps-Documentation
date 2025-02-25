### Introduction
- We are going to create following Azure Resources as part odf this section
    - azurerm_public_ip
    - azurerm_network_interface
    - azurerm_network_security_group
    - azurerm_network_interface_security_group_association
    - Terraform Local Block for Security Rule Ports
    - Terraform `for_each` Meta-argument
    - azurerm_network_security_rule
    - Terraform Local Block for defining custom data to Azure Linux Virtual Machine
    - azurerm_linux_virtual_machine
    - Terraform Outputs for above listed Azured Resources 
    - Terraform Functions
- [file](https://www.terraform.io/docs/language/functions/file.html)
- [filebase64](https://www.terraform.io/docs/language/functions/filebase64.html)
- [base64encode](https://www.terraform.io/docs/language/functions/base64encode.html)

#### Pre-requisite Note: 
- Copy all manifests files from the 4 tier network project (real word demo 1)  snce we will be reusing the same network design

- Create SSH Keys for Azure Linux VM
```sh
# Create Folder
cd manifests/
mkdir ssh-keys

# Create SSH Key
cd ssh-ekys
ssh-keygen  -m PEM  -t rsa  -b 4096  -C "azureuser@terraformdemo"  -f terraform-azure.pem 
# Important Note: If you give passphrase during generation, during everytime you login to VM, you also need to provide passphrase.

# List Files
ls -lrt ssh-keys/

### Files Generated after above command 
# Private Key: terraform-azure.pem
# Public Key: terraform-azure.pem.pub (Rename as terraform-azure.pub)
mv terraform-azure.pem.pub terraform-azure.pub


# Permissions for Pem file
chmod 400 terraform-azure.pem
```

#### **Step-01: c10-01-web-linuxvm-input-variables.tf**
- Place holder file for Linux VM Input Variables.

#### **Step-02: c10-02-web-linuxvm-publicip.tf**
To access the Linux virtual machine over the internet, a **public IP** must be assigned. 
- The **public IP** will be created using the `azurerm_public_ip` resource in Terraform. 
    - **Local reference**: `web_linuxvm_publicip`
    - A **clear naming convention** is maintained as multiple public IPs will be created in later sections:
        - **Standard Load Balancer**: Will require another public IP.
        - **NAT Gateway**: An additional public IP for app-tier subnets.

```hcl
resource "azurerm_public_ip" "web_linuixvm_publicip" {
    name = "${local.resource_name_prefix}-web-linuxvm-publicip"
    resource_group_name = azurerm_resource_group.myrg.name
    location = azurerm_resource_group.myrg.location
    allocation_method = "Static"
    sku = "Standard"
    domain_name_label = "app1-vm-${random_string.myrandom.id}"
  
}
```
| Attribute               | Description |
|-------------------------|-------------|
| `allocation_method`    | Uses **Static** allocation for consistent IP assignment. Options: `Static` or `Dynamic`. |
| `sku`                  | Uses **Standard** SKU for higher availability and resilience. Defaults to `Basic` if not specified. |
| `domain_name_label`    | Creates an **Azure DNS name** for the public IP using `app1-vm-${random_string.my_random.id}`. `random_string.my_random.id` ensures the domain label remains unique. |

**Understanding `domain_name_label` and `sku` in `azurerm_public_ip`**

When provisioning a **public IP** in Azure using Terraform, two essential attributes are commonly used:

1. **`domain_name_label`** – Used for creating an Azure-managed DNS label.
2. **`sku`** – Defines the type of public IP, affecting its features and security.

**`domain_name_label`**
- It is an **optional argument** used to define a **DNS label** for the public IP in Azure.
- It generates an **Azure-managed Fully Qualified Domain Name (FQDN)**.
- The final FQDN follows this format:   `<domain_name_label>.<region>.cloudapp.azure.com`
- Example: If the `domain_name_label` is `mywebapp` and the region is `eastus`, the resulting DNS name will be:   **`mywebapp.eastus.cloudapp.azure.com`**
- This domain name can be used **instead of the raw public IP** to access the virtual machine or other services.
- Users can **SSH into the VM** with:  `ssh username@<domain_name_label>.<region>.cloudapp.azure.com` Or access a web server running on the VM via `http://<domain_name_label>.<region>.cloudapp.azure.com`
**Why is `domain_name_label` Used?**
    - **Convenience**: Instead of remembering a public IP, users can use a friendly domain name.
    - **Dynamic IP Support**: If the IP is dynamic, the DNS name remains unchanged, allowing seamless access.
    - **Browser-Based Access**: Makes it easier to access a web application hosted on the VM.
    - **No Need for Custom DNS**: Azure provides a free domain name for temporary or non-critical applications.


**`sku`**
- The **SKU (Stock Keeping Unit)** defines the **type of public IP** being provisioned in Azure.
- It determines **availability, security, and feature set**.

**Available `sku` Values**
| SKU       | Description |
|-----------|-------------|
| **Basic** | - Supports **Dynamic & Static** allocation.  <br>- Works with all Azure services. <br>- **Lower availability & security**. <br>- Can be associated with **Basic Load Balancers**. |
| **Standard** | - **Higher availability & security**. <br>- **Only Static allocation** is supported. <br>- Works with **Standard Load Balancers**. <br>- Requires an explicit **Network Security Group (NSG)** for access (blocks all traffic by default). |

**Why is `sku` Used?**
- **Standard SKU** 
    - provides **better availability and security** for production workloads.
    - blocks all inbound traffic unless an **NSG rule** explicitly allows it.
- **Basic SKU** 
    - is simpler and commonly used for testing and development.
    - allows inbound traffic (e.g., SSH and HTTP) without an NSG.

### **Basic vs Standard SKU**
| Feature | Basic | Standard |
|---------|--------|----------|
| **Availability** | Lower | Higher |
| **Allocation Method** | Static / Dynamic | Only Static |
| **Security** | Less secure | More secure (NSG required) |
| **Load Balancer Support** | Basic Load Balancer | Standard Load Balancer |
| **Use Case** | Development / Testing | Production |
