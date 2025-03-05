### Method 1: Install Terraform on Ubuntu 24.04 through APT Repository

```bash
# Updated and Upgraded System Packages
sudo apt update -y
# Install Required Packages
sudo apt install gnupg software-properties-common -y
# download the HashiCorp GPG key for Terraform
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
# verify the key's fingerprint
gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint
# add the HashiCorp APT repository to your system’s list:
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
# Update Ubuntu Package List
sudo apt update
# Install Terraform via APT
sudo apt install terraform -y
```

### Method 2: Install Terraform on Ubuntu 24.04 from Binary
```bash
# Download the latest Terraform Binary
wget https://releases.hashicorp.com/terraform/1.9.3/terraform_1.9.3_linux_amd64.zip
# Extract Terraform Downloaded File
unzip terraform_1.9.3_linux_amd64.zip
# Copy the Terraform to the System’s PATH
sudo mv terraform /usr/local/bin/ -v
# verify
terraform -v
```