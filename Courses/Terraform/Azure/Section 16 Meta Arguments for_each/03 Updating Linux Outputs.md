### **Terraform Outputs for Web Linux VMs Using `for` Expressions**  


This section focuses on dynamically extracting and displaying outputs related to **Web Linux Virtual Machines (VMs)** using **for expressions** in Terraform. Since the VMs are created using `for_each`, directly referencing the resource attribute (`azurerm_linux_virtual_machine.web_linuxvm.private_ip_address`) will fail because it returns a **map of instances** instead of a single value.  

To handle this, **for expressions** will be used to iterate over the VM resources and extract the required values. The outputs will be structured in different formats:  
1. **List Output** – A list of private IP addresses of the VMs.  
2. **Map Output** – A mapping of VM names to their private IP addresses.  
3. **Nested For Expression** – A more advanced use case with two inputs.  

### **`for` Expression**
- A **`for` expression** can be used to:
  - Transform a list into another list.
  - Transform a map into another map.
  - Convert between lists and maps.
  - **Syntax for Lists**
    ```hcl
    [for item in list : transformed_value]
    ```
  - **Syntax for Maps**
    ```hcl
    { for key, value in map : new_key => new_value }
    ```
- Terraform provides the `keys()` and `values()` functions to extract specific parts of a **map**.  
  - **`keys(map)`**: Returns a list of keys from the given map.  
  - **`values(map)`**: Returns a list of values from the given map.  


### Step 5: Terraform Configuration for Linux Virtual Machines  Outputs 
- **1. Extracting Private IPs using `for` as a List**  
  - The following output generates a **list of private IP addresses** for the deployed Web Linux VMs:  
    ```hcl
    output "web_linuxvm_private_ip_address_asList" {
      description = "Web Linux Virtual Machine Private IP"
      value = [ for vm in azurerm_linux_virtual_machine.web_linuxvm : vm.private_ip_address]
    }
    ```
    - The output is enclosed in `[]` to indicate a list.  
    - The `for` expression iterates over `azurerm_linux_virtual_machine.web_linuxvm`.  
    - Each VM’s private IP address (`vm.private_ip_addresses`) is extracted.  
    - The result is a list of all private IPs, e.g.:  
      ```hcl
      [
        "10.0.1.5",
        "10.0.1.6"
      ]
      ```  
- **2. Extracting Private IPs using `for` as a Map**  
  - `{}` denotes that the output is a **map**. 
    ```hcl
    output "web_linuxvm_private_ip_address_asMap" {
      description = "Mapping of Web Linux VM Names to Private IP Addresses"
      value = { for vm in azurerm_linux_virtual_machine.web_linuxvm : vm.name => vm.private_ip_address }
    }
    ```
    - The `for` expression follows the syntax:  
      ```hcl
      { for <iterator> in <collection> : <key> => <value> }
      ```
    - Here, `vm.name` is used as the **key**, and `vm.private_ip_address` is the **value**.  
    - This means each VM’s **name** will be mapped to its **private IP address** in the output.  
    - This map format allows Terraform users to:  
      - Easily reference specific VMs and their private IPs in other parts of the configuration.  
      - Use outputs across different projects via **remote state data sources**.  


- **3. Extracting Keys from a Map using `keys()`**  
  - The `keys()` function takes a **map** as input and returns a **list** containing only the **keys** (VM names in this case).  
    ```hcl
    # Extracting VM names from the map
    output "web_linuxvm_private_ip_address_keys_function" {
      description = "List of VM names"
      value = keys({ for vm in azurerm_linux_virtual_machine.web_linuxvm : vm.name => vm.private_ip_address })
    }
    ```
    - **Example Output:**  
    ```hcl
    [
      "HR-Dev-Web-LinuxVM-VM1",
      "HR-Dev-Web-LinuxVM-VM2"
    ]
    ```
    - Here, only the **VM names** are extracted from the map.

- **4. Extracting Values from a Map using `values()`**  
  - The `values()` function takes a **map** as input and returns a **list** containing only the **values** (VM private IPs in this case).  
    ```hcl
    # Extracting VM private IP addresses from the map
    output "web_linuxvm_private_ip_address_values_function" {
      description = "List of VM private IP addresses"
      value = values({ for vm in azurerm_linux_virtual_machine.web_linuxvm : vm.name => vm.private_ip_address })
    }
    ```
    - **Example Output:**  
    ```hcl
    [
      "10.0.1.5",
      "10.0.1.6"
    ]
    ```
    - Here, only the **private IP addresses** are extracted from the map.

- **5. Generating a List of Network Interface IDs**  
  - To generate a **list** of network interface IDs, use **square brackets `[]`**, and extract only the `id` from each network interface resource.  
    ```hcl
    # Output List - Two Inputs to for loop (vm is the Iterator)
    output "web_linuxvm_network_interface_id_list" {
      description = "List of Web Linux VM Network Interface IDs"
      value       = [for vm, nic in azurerm_network_interface.web_linuxvm_nic : nic.id]
    }
    ```
  - **Example Output:**  
    ```hcl
    [
      "nic-id-1",
      "nic-id-2"
    ]
    ```
  - Here, only the **network interface IDs** are extracted as a **list**.


- **6. **Generating a Map of Network Interface IDs**  
  - To generate a **map** where each VM name is mapped to its network interface ID, use **curly braces `{}`** and set the **VM identifier as the key** and the **NIC ID as the value**.  
    ```hcl
    # Output Map - Two Inputs to for loop (vm is the Iterator)
    output "web_linuxvm_network_interface_id_map" {
      description = "Map of Web Linux VM Network Interface IDs"
      value       = { for vm, nic in azurerm_network_interface.web_linuxvm_nic : vm => nic.id }
    }
    ```
    - **Example Output:**  
    ```hcl
    {
      "vm1" = "nic-id-1",
      "vm2" = "nic-id-2"
    }
    ```
    - Here, each **VM identifier** (e.g., `vm1`, `vm2`) is mapped to its **network interface ID**.

---

### **Key Differences Between List and Map Outputs**  

| **Output Type** | **Syntax** | **Structure** | **Use Case** |
|---------------|----------|-----------|------------|
| **List** | `[for vm, nic in resource: nic.id]` | `["nic-id-1", "nic-id-2"]` | When only values are needed. |
| **Map** | `{for vm, nic in resource: vm => nic.id}` | `{"vm1" = "nic-id-1", "vm2" = "nic-id-2"}` | When a key-value mapping is needed. |

---

### **Use Cases for These Outputs**  
1. **Referencing in Other Terraform Modules** – The outputs can be used in **remote state data sources** for other projects.  
2. **Automating Network Configurations** – The outputs can be passed to security groups, firewall rules, or IAM policies.  
3. **Filtering and Debugging** – The map output helps in quickly identifying which VM corresponds to which NIC.  

By implementing `for` expressions with two inputs, Terraform configurations become more dynamic and adaptable.














### **Comparison of `keys()` and `values()` Functions**  

| **Function** | **Input (Map)** | **Output (List)** | **Use Case** |
|-------------|----------------|------------------|-------------|
| `keys()` | `{ "VM1" = "10.0.1.5", "VM2" = "10.0.1.6" }` | `["VM1", "VM2"]` | Extracts all **keys** (VM names). |
| `values()` | `{ "VM1" = "10.0.1.5", "VM2" = "10.0.1.6" }` | `["10.0.1.5", "10.0.1.6"]` | Extracts all **values** (VM private IPs). |

---

### **Use Cases of `keys()` and `values()`**  
1. **Referencing Terraform outputs** dynamically in scripts or external systems.  
2. **Filtering and iterating over VM resources** based on names or attributes.  
3. **Passing extracted values to other Terraform modules or remote states**.  

By applying these functions, Terraform users can efficiently process and organize infrastructure data.









### **Why Use These Outputs?**  
Terraform outputs are essential for referencing values in:  
1. **Other Terraform projects** (via **remote state**).  
2. **Infrastructure automation** (by passing values to external scripts).  
3. **Monitoring and logging tools** (by exporting outputs to dashboards).  

By mastering **for expressions** in Terraform outputs, infrastructure data can be structured for efficient management and automation.

### **Key Differences Between List and Map Outputs**  

| **Output Type** | **Syntax** | **Example Output** | **Use Case** |
|---------------|-----------|----------------|------------|
| **List Output** | `[ for vm in azurerm_network_interface.web_linuxvm_nic : vm.private_ip_addresses ]` | `["10.0.1.5", "10.0.1.6"]` | When only a collection of values is needed. |
| **Map Output** | `{ for vm in azurerm_linux_virtual_machine.web_linuxvm : vm.name => vm.private_ip_address }` | `{ "HR-Dev-Web-LinuxVM-VM1" = "10.0.1.5" }` | When key-value mapping is required for structured referencing. |
