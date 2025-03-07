## Installing a Web Server on the Linux Virtual Machine Using Custom Data  

In the previous lecture, the Linux Virtual Machine resource was created. However, to confirm that everything is functioning correctly, a sample application must be installed and accessed. This will ensure that the infrastructure setup is verified.  

To achieve this, a simple web server will be installed on the Linux VM using the `custom_data` option available in the Azure Linux VM resource.  

### Understanding `custom_data` in Terraform  

The `custom_data` attribute in the `azurerm_linux_virtual_machine` resource allows commands to be executed during VM initialization. These commands should be **Base64-encoded**. The custom data essentially bootstraps the VM with the required application setup.  
Custom data can be provided in multiple ways. 
- One approach is to store the script in the `app-scripts` folder. For example, a script file named `redhat-webvm-script.sh` contains the necessary commands to set up the web server.  
- Another method is that the script can be embedded directly inside a Terraform `locals` block and then pass that value

#### Reviewing the Shell Script Commands  

The script performs the following tasks:  

1. **Install the Apache HTTP server** (`httpd`).  
2. **Enable and start** the `httpd` service so that it restarts automatically on system reboots.  
3. **Disable and stop** the `firewalld` service (since this is a test environment, firewall rules are not enforced).  
4. **Grant full permissions** to the `/var/www/html/` directory, where the web content will be stored.  
5. **Create an `index.html` file** with the message:  
   ```
   Welcome to StackSimplify - WebVM App1 - VM hostname
   ```
   This file ensures that accessing the VM’s public IP displays the hostname.  
6. **Create an `app1` folder** and generate additional test files:  
   - `hostname.html`: Displays the VM hostname.  
   - `status.html`: Used for application gateway health checks.  
   - `index.html` (inside `app1`): Contains a formatted HTML page with colors.  
7. **Fetch and store VM metadata** in `app1/metadata.html`. The command:  
   ```
   curl -H Metadata:true "http://169.254.169.254/metadata/instance?api-version=2021-01-01" > /var/www/html/app1/metadata.html
   ```
   retrieves metadata such as VM size, region, and networking details.  

#### Method 1. Passing the Shell Script as Custom Data  

To reference the shell script inside the Terraform configuration:  

```hcl
custom_data = file("${path.module}/app-scripts/redhat-webvm-script.sh")
```
However, this **will not work** because Terraform requires the `custom_data` input to be **Base64-encoded**.  

To correctly pass the script, use the `filebase64()` function:  

```hcl
custom_data = filebase64("${path.module}/app-scripts/redhat-webvm-script.sh")
```
This function reads the script file and encodes it in Base64 format, ensuring compatibility with the `custom_data` attribute.  



#### Method 2.  Pass the script Using Terraform Locals for Custom Data  

Instead of storing the script externally, it can be embedded directly inside a Terraform `locals` block. This approach allows dynamic content, such as Terraform-generated values, to be inserted into the script.  

- **Defining the Locals Block**
```hcl
locals {
  webvm_custom_data = <<CUSTOM_DATA
        #!/bin/bash
        yum install -y httpd
        systemctl enable httpd
        systemctl start httpd
        systemctl stop firewalld
        systemctl disable firewalld
        chmod -R 777 /var/www/html
        echo "Welcome to StackSimplify - WebVM App1 - $(hostname)" > /var/www/html/index.html
        mkdir -p /var/www/html/app1
        echo "Welcome to StackSimplify - WebVM App1 - $(hostname)" > /var/www/html/app1/hostname.html
        echo "Status: OK" > /var/www/html/app1/status.html
        curl -H Metadata:true "http://169.254.169.254/metadata/instance?api-version=2021-01-01" > /var/www/html/app1/metadata.html
        CUSTOM_DATA
}
```
- **Encoding the Custom Data for Terraform** : Terraform requires the custom data to be Base64-encoded before passing it to the VM. This approach has the advantage of allowing dynamic content, such as VM public IPs or other Terraform-generated values, to be embedded within the script. 
    ```hcl
    custom_data = base64encode(local.webvm_custom_data)
    ```