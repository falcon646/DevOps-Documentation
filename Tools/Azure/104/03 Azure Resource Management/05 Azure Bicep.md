### **Azure Bicep**  

**Azure Bicep** is a **declarative Infrastructure as Code (IaC) language** designed to simplify **Azure resource deployments**. It offers a **more readable and manageable alternative** to **JSON-based ARM templates** while maintaining the same functionality.  

**Key Advantages of Bicep Over ARM Templates**  

1. **Simplified Syntax**  
   - **Bicep is easier to read and write** compared to **JSON-based ARM templates**.  
   - Reduces complexity and **eliminates the need for nested brackets** and repeated `"properties"` blocks.  
   - Example comparison:  
     - **ARM Template (JSON):**  
       ```json
       {
         "type": "Microsoft.Storage/storageAccounts",
         "apiVersion": "2021-04-01",
         "name": "mystorageaccount",
         "location": "East US",
         "sku": { "name": "Standard_LRS" },
         "kind": "StorageV2"
       }
       ```  
     - **Bicep Equivalent:**  
       ```bicep
       resource mystorage 'Microsoft.Storage/storageAccounts@2021-04-01' = {
         name: 'mystorageaccount'
         location: 'East US'
         sku: { name: 'Standard_LRS' }
         kind: 'StorageV2'
       }
       ```  
   - **Key Differences:**  
     - No need for `"type"`, `"apiVersion"`, or `"properties"` blocks.  
     - Uses **YAML-like indentation** for better readability.  

2. **Modular Approach with Smaller Files**  
   - **Bicep supports modularization**, allowing users to split complex deployments into **smaller, reusable modules**.  
   - Helps in organizing large projects **without cluttering a single file**.  
   - Example: A **VM module file** (`vm.bicep`) can be referenced inside the **main template**, making it reusable.  

3. **Automatic Dependency Detection**  
   - **Bicep automatically determines dependencies** between resources.  
   - Unlike ARM templates, **there is no need to manually define `dependsOn` attributes** for related resources.  
   - Example: If a **Virtual Network (VNet)** is referenced inside a **VM deployment**, Bicep **automatically deploys the VNet first**.  

4. **Visual Studio Code Extension for Bicep**  
   - **Provides IntelliSense, autocompletion, and error detection** while writing Bicep files.  
   - Helps **streamline** the development process, reducing syntax errors.  

### **Writing a Simple Azure Bicep File**

**1. Basic Bicep Structure**
A simple Bicep file typically consists of:
- **Parameters** (for input values)
- **Variables** (for reusable values)
- **Resources** (to define Azure services)
- **Outputs** (to return values after deployment)

**Example: Deploying a Virtual Network**
#### **Bicep File (`main.bicep`)**
```bicep
param location string = 'East US'
param vnetName string = 'myVNet'
param addressPrefix string = '10.0.0.0/16'

resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [addressPrefix]
    }
  }
}

output vnetId string = vnet.id
```

**Deploy the Bicep File**
- **Step 1: Install Bicep (If Not Installed)**
    ```sh
    az bicep install
    ```
- **Step 2: Deploy Using Azure CLI**
    ```sh
    az deployment group create --resource-group MyResourceGroup --template-file main.bicep
    ```
    - To pass parameters:
        ```sh
        az deployment group create --resource-group MyResourceGroup --template-file main.bicep --parameters location='West US' vnetName='prodVNet'
        ```