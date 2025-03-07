### **Terraform Output Values for Azure Linux Virtual Machine Deployment**

With the resources in place, the next step is to write the Terraform output values for these resources
####  **Step 06 : C10-06-web-linux-outputs.tf**
The first resource in the output file is the **Azure Public IP** (`azurerm_public_ip`). Terraform documentation can be referenced to understand the available arguments and attributes for this resource.
- **Public IP Output**
    - **Arguments:** Includes properties such as `name`, `resource_group_name`, `location`, `sku`, `sku_tier`, `allocation_method`, and `availability_zones`.
    - **Attributes:** Includes:
        - **`id`** – The unique identifier of the public IP resource.
        - **`ip_address`** – The assigned public IP address.
        The Terraform output definition references:
        ```hcl
        azurerm_public_ip.web_linux_vm_public_ip.ip_address
        ```
- **etwork Interface Output**
    -   For the network interface (`azurerm_network_interface`), relevant attributes include:
    - **`id`** – The unique identifier of the network interface.
    - **`private_ip_addresses`** – A list of all private IPs assigned to the interface.
        - If multiple private IPs are assigned, the `private_ip_addresses` attribute returns them as a list, whereas `private_ip_address` returns only the first private IP.
- **Linux Virtual Machine Output**
    -  For the Linux virtual machine (`azurerm_linux_virtual_machine`), attributes include:
        - **`public_ip_address`** – The public IP of the VM (same as assigned via `azurerm_public_ip`).
        - **`private_ip_address`** – The private IP of the VM.
        - **`id`** – The complete resource ID in Azure format (e.g., `/subscriptions/{subscription_id}/resourceGroups/{resource_group}/providers/Microsoft.Compute/virtualMachines/{vm_name}`).
        - **`virtual_machine_id`** – A 128-bit identifier for the virtual machine.