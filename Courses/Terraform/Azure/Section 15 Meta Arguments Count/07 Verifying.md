## Step-08: Execute Terraform Commands
```t
# Terraform Initialize
terraform init

# Terraform Validate
terraform validate

# Terraform Plan
terraform plan

# Terraform Apply
terraform apply -auto-approve
```

## Step-09: Verify Resources
```t
# Verify Resources - Virtual Network
1. Azure Resource Group
2. Azure Virtual Network
3. Azure Subnets (Web, App, DB, Bastion)
4. Azure Network Security Groups (Web, App, DB, Bastion)
5. View the topology
6. Verify Terraform Outputs in Terraform CLI

# Verify Resources - Web Linux VM (2 Virtual Machines)
1. Verify Network Interface created for 2 Web Linux VMs
2. Verify 2 Web Linux VMs
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

# Verify Standard Load Balancer Resources
1. Verify Public IP Address for Standard Load Balancer
2. Verify Standard Load Balancer (SLB) Resource
3. Verify SLB - Frontend IP Configuration
4. Verify SLB - Backend Pools
5. Verify SLB - Health Probes
6. Verify SLB - Load Balancing Rules
7. Verify SLB - Insights
8. Verify SLB - Diagnose and Solve Problems

# Access Application
http://<LB-Public-IP>
http://<LB-Public-IP>/app1/index.html
http://<LB-Public-IP>/app1/metadata.html

# Curl Test
curl http://<LB-Public-IP>
```

## Step-10: Verify Inbound NAT Rules for Port 22
```t
# VM1 - Verify Inbound NAT Rule
ssh -i ssh-keys/terraform-azure.pem -p 1022 azureuser@<LB-Public-IP>

# VM2 - Verify Inbound NAT Rule
ssh -i ssh-keys/terraform-azure.pem -p 2022 azureuser@<LB-Public-IP>

# VM3 - Verify Inbound NAT Rule
ssh -i ssh-keys/terraform-azure.pem -p 3022 azureuser@<LB-Public-IP>

# VM4 - Verify Inbound NAT Rule
ssh -i ssh-keys/terraform-azure.pem -p 4022 azureuser@<LB-Public-IP>

# VM5 - Verify Inbound NAT Rule
ssh -i ssh-keys/terraform-azure.pem -p 5022 azureuser@<LB-Public-IP>
```

## Step-11: Delete Resources
```t
# Delete Resources
terraform destroy 
[or]
terraform apply -destroy -auto-approve

# Clean-Up Files
rm -rf .terraform* 
rm -rf terraform.tfstate*
```

## Step-12: Additional Cautionary Note
- When your Linux VM NIC is associated with Security Group, the deletion criteria has issues with Azure Provider
- Due to that below related errors might come. This is provider related bug. 
- In our usecase we didn't associate any NSG to VMs directly, we are using subnet level NSG, so this error will not come for us. 
- Even this error comes when we associate NSG with VM NIC, just go to Azure Portal Console and delete that resource group so that all associated resources will be deleted. 
```t
azurerm_public_ip.bastion_host_publicip: Still destroying... [id=/subscriptions/82808767-144c-4c66-a320-...Addresses/hr-dev-bastion-host-publicip, 10s elapsed]
azurerm_subnet.bastionsubnet: Still destroying... [id=/subscriptions/82808767-144c-4c66-a320-...vnet/subnets/hr-dev-vnet-bastionsubnet, 10s elapsed]
azurerm_subnet.bastionsubnet: Destruction complete after 10s
azurerm_public_ip.bastion_host_publicip: Destruction complete after 12s
╷
│ Error: Error waiting for removal of Backend Address Pool Association for NIC "hr-dev-linuxvm-nic" (Resource Group "hr-dev-rg"): Code="OperationNotAllowed" Message="Operation 'startTenantUpdate' is not allowed on VM 'hr-dev-linuxvm1' since the VM is marked for deletion. You can only retry the Delete operation (or wait for an ongoing one to complete)." Details=[]