
### **1. Installing Terraform on Ubuntu 24.04**
```sh
# Ensure that your system is up to date and you have installed the gnupg, software-properties-common, and curl packages installed
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
# install the HashiCorp GPG key.
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
# Verify the key's fingerprint.
gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint
# Add the official HashiCorp repository to your system
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
# Install Terraform from the new repository.
sudo apt update && sudo apt install terraform
```
```sh
terraform version
```
Confirms that Terraform is installed.


### **2. Checking Terraform Commands**
To verify the installation, check available Terraform commands:
```sh
terraform help
```
For a specific command:
```sh
terraform help apply
terraform help plan
```


### **3. Installing Azure CLI**
If Azure CLI is not installed, install it using the following:

**For Ubuntu:**
```sh
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```
OR
```sh
sudo apt update && sudo apt install azure-cli -y
```

**Upgrade Azure CLI (if already installed)**
```sh
az upgrade
```

**Check Azure CLI Version**
```sh
az version
```


### **4. Authenticate with Azure**
**Login to Azure**
```sh
az login
```
This opens a browser where you can authenticate using your Azure account.

**List Azure Subscriptions**
```sh
az account list --output table
```
Shows available subscriptions.

**Set a Specific Subscription (If Multiple Exist)**
```sh
az account set --subscription "<SUBSCRIPTION_ID>"
```
If you have multiple subscriptions, use this command to set the correct one.


