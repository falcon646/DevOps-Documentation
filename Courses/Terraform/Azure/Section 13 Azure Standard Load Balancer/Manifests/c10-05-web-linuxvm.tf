# Resource: Azure Linux Virtual Machine
# Locals Block for custom data
locals {
webvm_custom_data = <<-CUSTOM_DATA
#!/bin/bash
echo "Updating package lists..."
sudo apt update -y
echo "Installing NGINX..."
sudo apt install -y nginx --no-install-recommends
echo "Starting and enabling NGINX..."
sudo systemctl start nginx
sudo systemctl enable nginx
WEBPAGE="/var/www/html/index.html"
echo "Creating a sample webpage..."
sudo tee $WEBPAGE > /dev/null <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome to NGINX</title>
    <style>
        body { text-align: center; font-family: Arial, sans-serif; }
        h1 { color: red; }
    </style>
</head>
<body>
    <h1>Welcome to My NGINX Web Server</h1>
</body>
</html>
EOF
echo "Setting permissions..."
sudo chmod 644 $WEBPAGE
echo "Restarting NGINX..."
sudo systemctl restart nginx
echo "NGINX is installed and serving a webpage with red text!"
CUSTOM_DATA  
}

resource "azurerm_linux_virtual_machine" "web_linuxvm"{
    name = "${local.resource_name_prefix}-web-linuxvm"
    resource_group_name = azurerm_resource_group.myrg.name
    location = azurerm_resource_group.myrg.location
    computer_name = "web-server"
    size = "Standard_DS1_v2"
    admin_username  = "azureuser"
    admin_ssh_key {
      username = "azureuser"
      public_key = file("${path.module}/ssh-keys/terraform-azure.pub")
    }
    os_disk {
        name = "${local.resource_name_prefix}-web-linuxvm-osdisk"
        caching = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }
    network_interface_ids = [ azurerm_network_interface.web_linuxvm_nic.id ]
    source_image_reference {
        publisher = "Canonical"
        offer = "0001-com-ubuntu-server-jammy"
        sku = "22_04-lts-gen2"
        version = "latest"
    }

    // Either pass the file directly and use filebas64 to base64 encode the data
    // custom_data = filebase64("${path.module}/app-scripts/redhat-webvm-script.sh")
    // or declare a local block and refer that

    custom_data = base64encode(local.webvm_custom_data)
}