# Create a Null Resource and Provisioners
resource "null_resource" "null_copy_ssh_to_bastion" {
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
        destination = "/tmp/terraform-azure.pem"
    }

    ## Remote Exec Provisioner: Using remote-exec provisioner fix the private key permissions on Bastion Host
    provisioner "remote-exec" {
       inline = [ "sudo mkdir /home/azureuser/.ssh" ,"sudo mv /tmp/terraform-azure.pem /home/azureuser/.ssh/id_rsa" ,"sudo chmod 400 /home/azureuser/.ssh/id_rsa" ,  ]
    }
}

# Creation Time Provisioners - By default they are created during resource creations (terraform apply)
# Destory Time Provisioners - Will be executed during "terraform destroy" command (when = destroy)