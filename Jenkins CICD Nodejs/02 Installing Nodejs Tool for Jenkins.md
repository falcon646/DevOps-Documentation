# **Setting Up and Using Node.js in Jenkins**

This section explains how to configure and use **Node.js** within **Jenkins**, covering both scenarios:  
- Using Node.js installed on the **host machine**  
- Installing and managing Node.js versions **within Jenkins**  

---

## **1. Checking Node.js Installation on the Host Machine**
Before configuring Jenkins, it is necessary to verify whether **Node.js** is already installed on the system.
- Run the following commands in a terminal on the jenkins node:  
     ```sh
     node -v
     npm -v
     ```
You can directly use nodejs and npm commands in Jenkins in this case
- ### **Steps to Create and Execute a Job**
1. **Go to Jenkins Dashboard** → Click on **New Item**  
2. Select **Freestyle Project**, name it `"NPM Version Test"`  
3. Click **OK**  
4. Scroll to **Build** → Click **Execute Shell**  
5. Add the following commands:  
   ```sh
   node -v
   npm -v
   ```
6. Click **Save** → Click **Build Now**  
7. Check the **Console Output**  
   - If the build is **successful**, it means Jenkins is using the **host machine’s Node.js installation**.

> **Note:** This works because **Jenkins is running on the same machine** where **Node.js is installed**. However, if Jenkins runs on a **separate agent**, Node.js might not be available.

## **2. Installing Node.js Plugin in Jenkins**
For environments where Node.js is **not pre-installed** or needs **version management**, the **Node.js Plugin** can be used.

- ### **Install the Node.js Plugin**
1. **Go to Jenkins Dashboard** → Click **Manage Jenkins**  
2. Click **Manage Plugins** → Go to **Available Plugins**  
3. Search for `"Node.js"` and select the plugin (e.g., **version 1.6.2**)  
4. Click **Install Without Restart**  

> **Note:** After installation, Jenkins requires some time to **load the plugin**.
- ### **Configuring Node.js in Jenkins**
Once the plugin is installed, Node.js must be added to **Jenkins Tool Configuration**.
1. **Go to Jenkins Dashboard** → Click **Manage Jenkins**  
2. Click **Global Tool Configuration**  
3. Scroll to **Node.js Installations**  
4. Click **Add Node.js**  
5. Enter the **Name** (e.g., `"NodeJS-22.6.0"`)  
6. Select the **Version** (e.g., `"22.6.0"`)  
7. Leave the remaining options as **default**  
8. Click **Save**  

> **Jenkins will download and manage this Node.js version automatically**.

- ### **Using Jenkins-Managed Node.js in a Job**
Now, Jenkins must be configured to use the **Node.js version installed via the plugin**.
1. **Go to Jenkins Dashboard** → Open NPM Version Test
2. Click **Configure**  
3. Scroll to **Build Environment**  
4. Enable `"Provide Node & NPM bin/ folder to PATH"`  
5. Select the **Node.js version** (`NodeJS-22.6.0`)  
6. Click **Save** → Click **Build Now**  

- ### **Checking the Output**
- The **first build** installs Node.js from **nodejs.org** into the **Jenkins tool directory**.  
- From the **second build onward**, it uses the pre-installed version.  
- Example output:  
  ```
  Node.js version: v22.6.0
  NPM version: 10.8.2
  ```

> **Key Difference:**  
> - The **first build** used **host machine’s** Node.js.  
> - The **second build** used **Jenkins-managed Node.js**.