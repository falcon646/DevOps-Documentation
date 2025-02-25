####  **Step 05 : c10-05-web-linuxvm.tf**

In this file, we will create two components:  
1. A local block for custom data.  
2. The Azure Linux virtual machine resource.  

We will first create the Azure Linux virtual machine resource and later pass custom data.

**Creating the Linux Virtual Machine Resource**  
We will use the `azurerm_linux_virtual_machine` resource.
Referencing the documentation, the Linux virtual machine resource requires the following attributes: 
- `resource_group_name`  
- `location`  
- **Virtual Machine Name and Hostname** : The `name` attribute specifies the virtual machine name, while the `computer_name` attribute defines the hostname of the VM. If `computer_name` is not specified, the `name` attribute value will be used as the hostname.
- `size` : we will use `Standard_DS1_v2` as the size. 
- `network_interface_ids` **(Associating the Network Interface)** 
    - The virtual machine must be associated with a network interface, which we created earlier. This allows access via the public IP on ports 80 (for application traffic) and 22 (for SSH). Both the Web NSG and VM NSG are associated with this VM for security.
    - The `network_interface_ids` attribute requires a list of network interfaces. Multiple network interfaces can be attached to a VM, which is common in high-security environments like banking systems. Each interface can handle different traffic types, such as management traffic, production traffic, and secure traffic.
    -  Since `network_interface_ids` expects a list, we specify it using square brackets:
    ```hcl
    network_interface_ids = [ azurerm_network_interface.web_linuxvm_nic.id ]
    ```
- `admin_username`  : The `admin_username` for Azure Linux virtual machines is typically set to `azureuser`. Using a consistent username simplifies SSH access.
- `admin_ssh_key` **(Adding SSH Key Authentication)**
    - The `admin_ssh_key` section requires:  
        - `username`: The same as `admin_username` (i.e., `azureuser`).  
        - `public_key`: The SSH public key to authenticate access.  
            - We reference the public key file stored in the `ssh-keys` folder:
        ```hcl
        admin_ssh_key {
            username   = "azureuser"
            public_key = file("${path.module}/ssh-keys/terraform-azure.pub")
        }
        ```
- `os_disk`  **(Configuring the OS Disk)**
    - The `os_disk` block defines the VM's operating system disk. Required attributes:  
        - `caching`: Set to `ReadWrite`.  
        - `storage_account_type`: Set to `Standard_LRS`. For production, `Premium_LRS` can be used.
        ```hcl
        os_disk {
            caching              = "ReadWrite"
            storage_account_type = "Standard_LRS"
        }
        ```
- `source_image_reference` **(Defining the Source Image)  **
    - The `source_image_reference` specifies the Linux distribution to use. The following attributes are required:  
        - `publisher`: The provider of the image (e.g., `RedHat`).  
        - `offer`: The product name (e.g., `RHEL`).  
        - `sku`: The specific SKU (e.g., `83-gen2`).  
        - `version`: Set to `latest` to use the most recent version.
    ```hcl
    source_image_reference {
      publisher = "RedHat"
      offer     = "RHEL"
      sku       = "83-gen2"
      version   = "latest"
    }
    ```