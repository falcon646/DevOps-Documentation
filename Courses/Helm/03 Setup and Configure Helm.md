## **Install Helm on Ubuntu 24.04**  

Helm, the package manager for Kubernetes, can be installed on Ubuntu 24.04 using different methods. Below are multiple approaches to installing Helm:

### **1. Install Helm via Apt (Recommended for Ubuntu Users)**
- Ubuntu provides Helm via the official package manager.
    ```bash
    curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
    sudo apt-get install apt-transport-https --yes
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
    sudo apt-get update
    sudo apt-get install helm
    ```
- **Pros:**  
    - Easy to install and update using `apt`.  
    - Comes from Ubuntu repositories.  
- **Cons:**  
    - Might not have the latest Helm version.  

### **2. Install Helm via Helm Script (Official Script)**
- Helm provides an official installation script for downloading and installing the latest version.
    ```bash
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
    chmod 700 get_helm.sh
    ./get_helm.sh
    ```
- **Pros:**  
    - Installs the latest version directly from the Helm project.  
    - Works on any Linux distribution.  
- **Cons:**  
    - Running scripts from the internet is a potential security risk.  



### **3. Install Helm via Snap (Snap Package Manager)**
Snap provides an easy way to install and manage Helm.
```bash
sudo snap install helm --classic
```
- **Pros:**  
    - Easy to update and maintain using `snap refresh helm`.  
    - Works across multiple Linux distributions.  
- **Cons:**  
    - Snap-based applications run in a sandboxed environment, which might cause permission issues in some scenarios.  



### **4. Install Helm via Binary (Manual Installation)**
For users who want full control, Helm can be installed manually from the official releases.

For users who want full control, Helm can be installed manually from the official releases.
```bash
# Download the latest Helm binary [Helm Releases](https://github.com/helm/helm/releases)).*
wget https://get.helm.sh/helm-v3.13.2-linux-amd64.tar.gz
# Extract the files
tar -zxvf helm-v3.13.2-linux-amd64.tar.gz
# Move Helm binary to `/usr/local/bin/`
sudo mv linux-amd64/helm /usr/local/bin/helm
# Verify installation:
helm version
```
- **Pros:**  
    - Ensures installation of the exact version required.  
    - No dependency on package managers.  
- **Cons:**  
    - Requires manual updates.  

