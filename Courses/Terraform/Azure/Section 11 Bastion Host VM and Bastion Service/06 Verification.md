#### Step-01: Execute Terraform Commands
```t
# Terraform Initialize
terraform init

# Terraform Validate
terraform validate

# Terraform Plan
terraform plan

# Terraform Apply
terraform apply -auto-approve

# Important Note: 
1. Azure Bastions Service takes 10 to 15 minutes to create. 
```


#### Step-02: Verify Resources - Bastion Host
```t
# Verify Resources - Virtual Network
1. Azure Resource Group
2. Azure Virtual Network
3. Azure Subnets (Web, App, DB, Bastion)
4. Azure Network Security Groups (Web, App, DB, Bastion)
5. View the topology
6. Verify Terraform Outputs in Terraform CLI

# Verify Resources - Web Linux VM 
1. Verify Network Interface created for Web Linux VM
2. Verify Web Linux VM
3. Verify Network Security Groups associated with VM (web Subnet NSG)
4. View Topology at Web Linux VM -> Networking
5. Verify if only private IP associated with Web Linux VM

# Verify Resources - Bastion Host
1. Verify Bastion Host VM Public IP
2. Verify Bastion Host VM Network Interface
3. Verify Bastion VM
4. Verify Bastion VM -> Networking -> NSG Rules
5. Verify Bastion VM Topology

# Connect to Bastion Host VM
1. Connect to Bastion Host Linux VM
ssh -i ssh-keys/terraform-azure.pem azureuser@<Bastion-Host-LinuxVM-PublicIP>
sudo su - 
cd /tmp
ls 
2. terraform-azure.pem file should be present in /tmp directory

# Connect to Web Linux VM using Bastion Host VM
1. Connect to Web Linux VM
ssh -i ssh-keys/terraform-azure.pem azureuser@<Web-LinuxVM-PrivateIP>
sudo su - 
cd /var/log
tail -100f cloud-init-output.log
cd /var/www/html
ls -lrt
cd /var/www/html/app1
ls -lrt
exit
exit
```

#### Step-03: Verify Resources - Bastion Service
```t
# Verify Azure Bastion Service
1. Go to Azure Management Porta Console -> Bastions
2. Verify Bastion Service -> hr-dev-bastion-service
3. Verify Settings -> Sessions
4. Verify Settings -> Configuration

# Connect to Web Linux VM using Bastion Service
1. Go to Web Linux VM using Azure Portal Console
2. Portal Console -> Virtual machines -> hr-dev-web-linuxvm ->Settings -> Connect
3. Select "Bastion" tab -> Click on "Use Bastion"
- Open in new window: checked
- Username: azureuser
- Authentication Type: SSH Private Key from Local File
- Local File: Browse from ssh-keys/terraform-azure.pem
- Click on Connect
4. In new tab, we should be logged in to VM "hr-dev-web-linuxvm" 
5. Run additional commands
sudo su - 
cd /var/www/html
ls 
cd /var/www/html/app1
ls

# Verify Bastion Sessions 
1. Go to Azure Management Porta Console -> Bastions
2. Verify Bastion Service -> hr-dev-bastion-service
3. Verify Settings -> Sessions
```

#### Step-04: Delete Resources
```t
# Delete Resources
terraform destroy 
[or]
terraform apply -destroy -auto-approve

# Clean-Up Files
rm -rf .terraform* 
rm -rf terraform.tfstate*
```
