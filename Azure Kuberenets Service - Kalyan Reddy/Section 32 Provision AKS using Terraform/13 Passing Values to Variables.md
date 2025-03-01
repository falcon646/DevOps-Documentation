### Passing Terraform Input Variables values

In the previous section,were covered, along with defining input variables. Now, the focus is providing values at runtime.  

There are two primary options for passing input variables:  
1. **Using `-var` flag**  
2. **Using `-var-file` flag**   
3. **Environmental Variables**   

#### **Option 1: Using the `-var` Flag**
- The `-var` flag allows input variable values to be passed directly to the Terraform project at runtime.  
- For example, if the default `location` variable in `variables.tf` is set to `"Central US"`, running `terraform plan` will display `"Central US"` as the location. However, this default value can be overridden using the `-var` flag:  
    ```sh
    terraform plan -var="location=East US"
    ```
- Executing this command will update the location to `"East US"` instead of `"Central US"` because the variable value is overridden at runtime.  Similarly, the resource group name can also be overridden: 
    ```sh
    terraform plan -var="location=East US" -var="resource_group_name=dev-eastus"
    ```
- However, if multiple variables need to be passed (e.g., 50 variables), using `-var` repeatedly becomes tedious. A more efficient method is available using **Option 2**.  

#### **Option 2: Using the `-var-file` Flag**
- Instead of passing multiple `-var` arguments, Terraform allows defining a file containing variable values. This can be done using the `-var-file` flag.  
    - Create a file named **`terraform.tfvars`** (or any custom name like `dev.tfvars`).  
    - Define the variables inside the file:  
        ```hcl
        location = "West US"
        resource_group_name = "Callian123"
        ```
    - Run Terraform with the `-var-file` option:  
        ```sh
        terraform plan -var-file="terraform.tfvars"
        ```
    - This will override the values from `variables.tf` with those defined in `terraform.tfvars`.  
    - If the file is named **`terraform.tfvars`**, Terraform automatically loads it without requiring the `-var-file` flag. Running `terraform plan` or `terraform apply` will pick values from `terraform.tfvars` automatically:  
        ```sh
        terraform plan
        ```
    - However, if the file has a different name (e.g., `dev.tfvars`), it must be explicitly specified:  
        ```sh
        terraform plan -var-file="dev.tfvars"
        ```
    - the values in **`terraform.tfvars`** (or the specified file) will override the defaults, ensuring the correct configuration is applied.

- **There is another way to avoid scpeicfying the `-var-file="<file_name>.tfvars"` flag when you are using custom name for the terraform.tfvars file. To do this insert `.auto.` in between the custom name and tfvars. ie `<customname>.auto.tfvars`. When you name your tfvars file like this, you don not need to specify the `-var-file` flag**

#### **Option 3: With Environment Variables**
- When running Terraform commands, we can also use Environment Variables to define the values for Input Variables
- Important Note: Be sure to keep in mind that if the Operating System is case-sensitive, then Terraform will match variable names exactly as given during configuration.
    ```sh
    # Template
    # TF_VAR_<VARIABLE-NAME>=<value>  // case-sensitive
    # Set Environment Variable using Bash
    export TF_VAR_location="westus"

    # validate
    terraform plan

    # unset env var
    unset TF_VAR_location
    ```