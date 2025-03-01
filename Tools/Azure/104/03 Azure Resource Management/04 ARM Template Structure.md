### **ARM Template Structure**  

An **Azure Resource Manager (ARM) template** consists of key components that define how resources are deployed in Azure. Some elements are **mandatory**, while others are **optional** but useful for enhancing flexibility and maintainability.  

**Componenets of a ARM template**  
1. **Schema**  
   - Specifies the location of the **JSON schema** that defines the ARM template language version.  
   - The **schema changes based on deployment scope** (e.g., Tenant, Management Group, Subscription, or Resource Group).  
   - Acts as a **grammar** for ARM templates, ensuring compliance with Azure's JSON structure.  
   ```json
   {
        "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#"
    }
    ```


2. **Content Version**  
   - Specifies the **version number** of the template.  
   - The default is `1.0.0.0`, but any versioning scheme can be used.  
   - **Useful for version control** when storing templates in repositories like GitHub.  
   - Example:  
     - `1.0.0.0 → Initial version`  
     - `1.0.0.1 → Minor update`  
     - `2.0.0.0 → Major changes`  
    ```json
    {
        "contentVersion": "1.0.0.0"
    }
    ```

3. **Resources**  
   - Defines **Azure resources** to be deployed.  
   - Every resource (VM, App Service, Storage, etc.) is specified within the **resources** block.  
   - Example:  
     - Deploying an **App Service Plan** using a **location parameter** instead of hardcoding values.
    ```json
    {
    "resources": [
        {
        "type": "Microsoft.Web/serverfarms",
        "apiVersion": "2020-12-01",
        "name": "[variables('publicIPName')]",
        "location": "[parameters('location')]",
        "sku": {
            "tier": "Standard",
            "size": "S1"
        },
        "properties": {}
        }
    ]
    }
    ```  

### **Optional Elements**  
4. **Parameters**  
   - **Dynamic inputs** that allow values to be specified **at runtime**.  
   - Helps in **template reusability** without modifying the template file.  
   - Example:  
     ```json
     "parameters": {
       "location": {
         "type": "string",
         "defaultValue": "East US",
         "allowedValues": ["East US", "West US"],
         "metadata": {
           "description": "Specifies the deployment region."
         }
       }
     }
     ```  
   - The parameter enforces that only **East US or West US** can be used and defaults to **East US** if no value is provided.  

5. **Variables**  
   - Stores **hardcoded values** that can be reused throughout the template.  
   - **Difference from Parameters:** Variables **cannot** be changed at runtime.  
   - Example:  
     ```json
     "variables": {
       "publicIpName": "appgwpip"
     }
     ```  
   - If the IP name needs to be changed later, only the **variable value** needs updating.  

6. **Functions**  
   - Defines **custom reusable logic** inside the template.  
   - Helps **avoid repetitive code** by defining a function once and calling it multiple times.  
   - Example: A function to **generate VM names dynamically**:  
     ```json
     "functions": [
       {
         "name": "generateVMName",
         "outputs": {
           "value": "[concat('vm-', uniqueString(resourceGroup().id))]"
         }
       }
     ]
     ```  
   - This function generates a **unique VM name** by appending a random string to `"vm-"`.  

7. **Outputs**  
   - Displays values **after deployment**, such as **public IP addresses**.  
   - Useful for retrieving **dynamic values** without manually checking deployed resources.  
   - Example: Returning the **public IP** after deployment:  
     ```json
     "outputs": {
       "publicIpAddress": {
         "type": "string",
         "value": "[reference(parameters('publicIpName')).ipAddress]"
       }
     }
     ```  

#### Deploying a ARM template

Save the template as `template.json`
```sh
# deploy the template
az deployment group create --resource-group MyResourceGroup --template-file template.json
```
