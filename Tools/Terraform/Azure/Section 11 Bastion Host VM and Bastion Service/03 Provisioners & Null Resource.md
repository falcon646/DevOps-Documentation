# **Terraform Provisioners and Null Resources**

This document explores:
- Terraform **provisioners** and their types.
- The **null resource** and its use case.
- The **connection block** and how it facilitates provisioning.
- An implementation example of moving an SSH key to an **Azure Bastion Host** using Terraform provisioners.

## **Terraform Provisioners**  
Terraform provisioners are used to execute scripts or commands on local or remote machines as part of resource creation or destruction. Provisioners are a last-resort mechanism and should only be used when no other Terraform-native solutions (such as providers) are available. 

**What is a Terraform Provisioner?**  
- Terraform **provisioners** allow executing scripts or commands on **local** or **remote** machines during resource provisioning.  
- They are typically used for **initial setup** and **configuration management** on VMs.  
- Terraform must have network access to the remote machine to execute a provisioner.
- Provisioners operate only at **creation time** and **destroy time**; they are not executed during in-place updates.

**Use Cases of Provisioners**  
- Passing **data** into virtual machines and compute resources.  
- Running configuration management tools (such as Ansible, Chef, Puppet).
- Executing custom scripts during resource creation or destruction.  
- Executing commands on virtual machines.
- Copying files to remote machines.


**Why Avoid Using Provisioners When Possible?**  
- **Provisioners are a last resort.**  
- If Terraform **providers** offer built-in functionality, use them instead of **Provisioners**.  
- Provisioners should only be used **when absolutely necessary**.  

**Best Practice Before Using Provisioners**  
- Always **check for first-class Terraform provider functionality** before using provisioners.  
- If **native Terraform provider support exists**, use that instead of a provisioner.  

**Types of Terraform Provisioners**  : Terraform provisioners are classified based on when they execute:  
- **Creation-Time Provisioners**  : executes **during resource creation**.  
- **Destroy-Time Provisioners**  : executes **when a resource is deleted**.  
    - **Provisioners do not run on in-place updates.**  
    - If a resource requires **re-execution of the provisioner**, the resource must be **tainted and recreated**.  


| **Provisioner Type**      | **Execution Time** |
|---------------------------|--------------------|
| **Creation-Time Provisioner**  | Runs when the resource is **created**. |
| **Destroy-Time Provisioner**  | Runs when the resource is **destroyed**. |


#### **Terraform Provisioner Failure Behavior (fail and continue)**  

**Default Failure Behavior (fail)**  
- If a provisioner **fails**, Terraform:  
  - **Raises an error** and stops `terraform apply`.  
  - **Taints the resource**, marking it for recreation in the next apply.  
    - **Tainting in Terraform**  
        - If a provisioner fails, the associated resource is **tainted**.  
        - The next `terraform apply` will **destroy and recreate the resource**.  

**Overriding Default Behavior (continue)**  
- If the provisioner **is not critical**, Terraform can be configured to **continue execution even if the provisioner fails**.  
- This is done using the `on_failure = continue` option inside the provisioner block.  
- If set to `continue`, Terraform will proceed even if the provisioner fails.  


### **Terraform Provisioner Types**  

#### **1. File Provisioner**  
- Transfers **files** from the local machine to a **remote VM**.  
- Used to **copy SSH keys**, scripts, or configuration files.  
   **Example:**
   ```hcl
   resource "null_resource" "file_transfer" {
     provisioner "file" {
       source      = "terraform-azure.pem"
       destination = "/tmp/terraform-azure.pem"
     }

     connection {
       type        = "ssh"
       user        = "adminuser"
       private_key = file("~/.ssh/id_rsa")
       host        = azurerm_linux_virtual_machine.bastion.public_ip_address
     }
   }
   ```
#### **2. Remote-Exec Provisioner**  
- Executes **commands or scripts** on a **remote VM**.  
- Requires an SSH or WinRM connection.  
   **Example:**
   ```hcl
   provisioner "remote-exec" {
     inline = [
       "chmod 400 /tmp/terraform-azure.pem"
     ]
   }
   ```
#### **3. Local-Exec Provisioner**  
- Executes **commands** on the **local machine running Terraform**.  
- Useful for actions like sending API calls, notifying monitoring systems, or running local scripts. 
   **Example:**
   ```hcl
   provisioner "local-exec" {
     command = "echo 'VM Created at: ' $(date) > creation_time.txt"
   }
   ``` 
#### **4. Destroy-Time Provisioners**
- Provisioners can also execute commands when a resource is being **destroyed**.
- Example: Logging the destruction of a VM.
   ```hcl
   provisioner "local-exec" {
     when    = destroy
     command = "echo 'VM Destroyed at: ' $(date) > destroy_time.txt"
   }
   ```
#### **Other Provisioners**  
- Terraform also supports provisioners for **Chef** and **Puppet**, which integrate with configuration management tools.  



## **Understanding the Connection Block**
Most provisioners require network access to the remote machine via **SSH** or **WinRM**. This is managed using the **connection block**. (we cannt use provisioners to a vm with only private ip)

- The **connection block** defines how Terraform can connect to a remote machine.
- Expressions in connection block cannot refer to their parent resource by name . When used inside a **Linux VM resource**, `self` can be used to reference attributes such as `self.public_ip_address` and `self.admin_username`.
- When used inside a **null resource**, explicit references to other resources (e.g., `azurerm_linux_virtual_machine.bastion.public_ip_address`) must be provided.
- **Example: Using a Connection Block**
```hcl
connection {
  type        = "ssh"
  user        = "adminuser"
  private_key = file("~/.ssh/id_rsa")
  host        = azurerm_linux_virtual_machine.bastion.public_ip_address
}
```

---

## **Terraform Null Resource**

A **null resource** is a special Terraform resource that does not provision infrastructure but can execute provisioners.
- same as other resources, you can configure provisioners and connection blocks on a null_resource

**Why Use a Null Resource?**
- **Decouples provisioners from real resources.**
- **Prevents modifying live infrastructure** (e.g., avoiding the need to taint a VM just to re-run a provisioner).
- **Triggers provisioners independently** when certain dependencies change.

**Example: Using a Null Resource for SSH Key Transfer**
This example demonstrates how to transfer an SSH private key from the local machine to an **Azure Bastion Host VM**, ensuring the key has appropriate permissions.

```hcl
resource "null_resource" "ssh_key_transfer" {
  provisioner "file" {
    source      = "terraform-azure.pem"
    destination = "/tmp/terraform-azure.pem"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 400 /tmp/terraform-azure.pem"
    ]
  }

  connection {
    type        = "ssh"
    user        = "adminuser"
    private_key = file("~/.ssh/id_rsa")
    host        = azurerm_linux_virtual_machine.bastion.public_ip_address
  }
}
```
