Now , we'll apply the manifest file to let terraform create the resources

After successfully deploying the Azure Virtual Machine (VM), the next step involves connecting to the VM, verifying its configuration, and ensuring that the web server is running as expected.

**Connecting to the Azure Linux VM via SSH**
To establish a secure SSH connection to the VM, the following command is used:

```sh
ssh -i ssh-key/terraform-azure.pem azureuser@<public-ip>
```
- **`-i ssh-key/terraform-azure.pem`**: Specifies the private key file required for authentication.
- **`azureuser@<public-ip>`**: Connects to the VM using the public IP.


**Verifying Cloud Initialization Logs**
Upon connection, the cloud initialization logs are examined to confirm that the web server was installed and configured successfully.

1. **Switch to the root user:**
   ```sh
   sudo su -
   ```
2. **Navigate to the log directory:**
   ```sh
   cd /var/log
   ```
3. **Check cloud-init logs for provisioning details:**
   ```sh
   tail -100f cloud-init-output.log
   ```
   - This log contains information about the execution of the custom user data script.
   - If the HTTPD installation was successful, the log should display:
     ```
     Installing HTTPD server...
     ```
   - The provisioning time is also recorded, typically taking **6-8 minutes**.

4. **Check if the web server process is running:**
   ```sh
   ps -ef | grep httpd
   ```
5. **Confirm that the web server is listening on port 80:**
   ```sh
   netstat -lntp
   ```
   - If successful, the output should indicate that the server is listening on **port 80**.

**Verifying Web Server and Static Content**
The static files are stored in the following directory:
```sh
cd /var/www/html/app1
```
Key files include:
- **`index.html`** – Main application page.
- **`hostname.html`** – Displays the VM hostname.
- **`status.html`** – Provides application status.
- **`metadata.html`** – Contains VM metadata.

To confirm the correct hostname, run:
```sh
hostname
```
This should return the assigned hostname.

**Accessing the Web Server via Browser**
Once the HTTPD server is verified, the application can be accessed using the **VM's public IP** in a web browser:

```sh
http://<public-ip>
```
The expected output is:
```
Welcome to StackSimplify WebVMApp1
```
- **`WebVMApp1`** is displayed because this VM will later act as a web server in front of an application VM with a **Standard Load Balancer**.
- The VM metadata is accessible at:
  ```
  http://<public-ip>/app1/metadata.html
  ```

**Reviewing VM Metadata**
The `metadata.html` file provides details such as:
- **Operating System**: `RHEL`
- **VM Name**: `hr-dev-web-linuxvm`
- **Admin User**: `azureuser`
- **OS Type**: `Linux`
- **Public Key**: Stored inside the VM.
- **Resource Group** and **Resource ID**.
- **Network Information**: Public and private IPs, subnet (`10.1.1.0/24`), and MAC address.

To format the metadata properly in the browser, a **JSON Viewer plugin** can be installed.

**Accessing the VM Using a DNS Label**
Instead of using the public IP, the VM can also be accessed using its **DNS label**, found in the Azure portal under **Public IP settings**.

Example:
```sh
http://<dns-label>/metadata.html
```
The same metadata and application files are accessible through the DNS label.