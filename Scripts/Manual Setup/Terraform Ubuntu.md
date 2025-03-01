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
terraform version
```