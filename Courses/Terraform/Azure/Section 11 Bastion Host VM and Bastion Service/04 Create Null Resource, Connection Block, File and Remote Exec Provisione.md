### **Terraform Null Resource with SSH Connection Block**  
This section of the lecture explains how to create a **null resource** that connects to an **Azure Bastion Host VM** using **SSH**. The null resource acts as a placeholder to execute provisioners that copy and modify SSH keys.


**c11-03-move-ssh-key-to-bastion-host.tf**

- **1. Defining the Null Resource** : A **null resource** in Terraform allows executing provisioners **without modifying existing resources**. It is created using:
    ```hcl
    resource "null_resource" "null_copy_ssh_to_bastion" {
        depends_on = [azurerm_linux_virtual_machine.bastion_host_linuxvm]
    }
    ```
    - **`depends_on`** → Ensures that the null resource executes **only after** the `bastion_host_linuxvm` is successfully created.
    - You also need to add the null resource under `required_providers`
        ```sh
        null = {
            source = "hashicorp/null"
            version = ">= 3.0"
        } 
        ```
- **2. Adding the Connection Block** : The **connection block** specifies how Terraform will SSH into the Bastion Host
    - **`type = "ssh"`** → Specifies SSH as the connection method.
    - **`host = public_ip_address`** → Uses the **Bastion Host’s public IP** for connection.
    - **`user = admin_username`** → Uses the **admin username** of the Bastion VM.
    - **`private_key = file(...)`** → Loads the **private key** stored in `ssh-keys/terraform-azure.pem` for authentication.
        ```sh
        resource "null_resource" "null_copy_ssh_to_bastion" {

            connection {
                type        = "ssh"
                host        = azurerm_linux_virtual_machine.bastion_host_linuxvm.public_ip_address
                user        = azurerm_linux_virtual_machine.bastion_host_linuxvm.admin_username
                private_key = file("${path.module}/ssh-keys/terraform-azure.pem")
            }
        }
        ```
- **Important Considerations**
    - The Bastion VM **must** have a **public IP** for SSH connections unless another method (e.g., a private network jump host) is used.  
    - `${path.module}` ensures that the SSH key file path is **relative to the module directory**, preventing absolute path issues.  
    - The `depends_on` argument ensures that Terraform does **not** attempt to execute the connection block before the Bastion VM is created.  
- **3. Adding the Terraform Provisioners: File and Remote-Exec**  
    - **1. File Provisioner** : The **File Provisioner** in Terraform is used to **transfer files from the local machine to a remote VM** over SSH.  
        ```sh
        resource "null_resource" "null_copy_ssh_to_bastion" {

            provisioner "file" {
                source      = "ssh-keys/terraform-azure.pem"
                destination = "/tmp/terraform-azure.pem"
            }
        }
        ```
        - **`source`** → Specifies the local file (`terraform-azure.pem`) that needs to be copied.  
        - **`destination`** → Specifies the target location (`/tmp/terraform-azure.pem`) on the Bastion VM.  
        - **`on_failure = "continue"`** → (optional) Ensures that even if this provisioner fails, Terraform will proceed with execution. 
        - By default, **provisioners execute during the "create" phase** of the resource.  
        - To run it **during destruction**, use `when = "destroy"`.  

    - **2. Remote-Exec Provisioner**: The **Remote-Exec Provisioner** is used to execute **remote commands** on the VM **after** the file has been copied.
        ```sh
        resource "null_resource" "null_copy_ssh_to_bastion" {

            provisioner "remote-exec" {
                inline = [
                    "sudo chmod 400 /tmp/terraform-azure.pem"
                ]
            }
        }
        ```
        - **`inline = [...]`** → Executes a list of commands **sequentially** on the VM.
        - **`sudo chmod 400 /tmp/terraform-azure.pem`**  
        - Modifies the SSH key file's permissions to **read-only** for security.  
        - Prevents unauthorized access to the private key.  
  
**Complete Null Resource Configuration  with Provisioners**
```hcl
# Create a Null Resource and Provisioners
resource "null_resource" "nul_copy_ssh_to_bastion" {
    depends_on = [ azurerm_linux_virtual_machine.bastion_host_linuxvm  ]

    # Connection Block for Provisioners to connect to Azure VM Instance
    connection {
      type = "ssh"
      host = azurerm_linux_virtual_machine.bastion_host_linuxvm.public_ip_address
      user = azurerm_linux_virtual_machine.bastion_host_linuxvm.admin_username
      private_key = file("${path.module}/ssh-keys/terraform-azure.pem")
    }

    ## File Provisioner: Copies the terraform-key.pem file to /tmp/terraform-key.pem
    provisioner "file" {
        source = "ssh-keys/terraform-azure.pem"
        destination = "/tmp/ssh-keys/terraform-azure.pem"
    }

    ## Remote Exec Provisioner: Using remote-exec provisioner fix the private key permissions on Bastion Host
    provisioner "remote-exec" {
       inline = [ "sudo chmod 400 /tmp/ssh-keys/terraform-azure.pem" ]
    }
}
```