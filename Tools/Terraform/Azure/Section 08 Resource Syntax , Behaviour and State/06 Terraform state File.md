### Terraform State file
Terraform must store state about your managed infrastructure and configuration to track real-world resources and map them to your Terraform configuration files.
- This state file improves performance, particularly for larger infrastructures, and helps with metadata tracking.
- The primary purpose of Terraform state is to store the bindings between remote system resources (e.g., Azure Cloud) and the instances declared in your Terraform configuration files.
- Terraform tracks the identity of remote objects in the cloud and updates or releases those objects based on changes in the configuration.
- By default, Terraform stores the state file locally in a file named `terraform.tfstate`.
    - However, in a team environment, it is **recommended to store the state remotely**, which provides better collaboration and management.

**When is the Terraform state file  created?**
- Whenever you run the `terraform apply` command, Terraform communicates with Azure APIs to check if it can create the resources defined in your configuration.
- Similarly, during the `terraform plan` phase, Terraform also communicates with Azure APIs to verify what changes can be made and prints the plan.
- Only once , the `terraform apply` command is executed, the Terraform state file is created. 
- To clarify, the state file is not created during `terraform init`. It is created only after you run `terraform apply`. At this point, Terraform will store all the information about the remote resources it created in the `terraform.tfstate` file.
- Whenever you run `terraform destroy`, Terraform will delete the resources in the cloud and also remove the corresponding entries from the state file. 
- Therefore, running `terraform apply` updates the state file with the current configuration and remote resource information, while running `terraform destroy` removes the data of deleted resources from the state file.

**Terraform State for Ongoing Changes:**
- The state file is not just for the initial creation of resources. When configuration changes are made (e.g., changing tags on a virtual network), Terraform will update the state file to ensure that the configuration and real-world resources remain synchronized.
- The `terraform state` ensures that both the configuration and the actual infrastructure are consistently tracked.



### **Reviewing the terraform.tfstate File**
After running `terraform apply`, Terraform creates the `terraform.tfstate` file, which contains information about the resources Terraform manages.
- The state file includes:
    - **Version**: Terraform version used.
    - **Terraform Version**: e.g., `1.0.0`.
    - **Serial** and **Lineage**: Identifiers for tracking and maintaining the state file.
    - **Output**: Contains output values defined in the configuration.
    - **Resources**: The most important section for us, as it tracks all the resources Terraform manages. It includes a detailed record of each resource and its metadata.

**Understanding Resource Metadata:**
- In the state file, each resource, such as `network_interface`, `public_ip`, `resource_group`, `subnet`, and `virtual_network`, is represented by a block.
- Each resource block contains metadata related to that specific resource.
- Example: **Azure Public IP** (`azurerm_public_ip`) contains metadata like:
    - **allocation_method**: The method configured (e.g., `Static` or `Dynamic`).
    - **availability_zone**: If not configured, it defaults to `No-Zone`.
    - **fqdn (Fully Qualified Domain Name)**: If not configured, it will show as `null`.
    - **ID**: The unique identifier of the resource once it's created in the cloud.
    - **Other attributes**: Even if some attributes were not configured in the Terraform configuration file, the default values (e.g., `ideal_time_in_minutes`) will be populated in the state file based on cloud defaults.

**Terraform State File and Real-World Environment:**
- The `terraform.tfstate` file records the actual state of resources in the cloud environment, such as their **IDs**, **default values**, and other **cloud-generated metadata**.
- Even if you didn’t configure certain attributes, Terraform will update the state file with those values (e.g., default settings from Azure).
- **Manual Editing of State File**: It is highly **not recommended** to manually edit the `terraform.tfstate` file as it may cause inconsistencies and errors.
- **Local vs Remote State**: Using **local state files** for production-grade infrastructure is **not recommended**. It is better to use **remote backends** for managing the state, which ensures better collaboration and reliability. Remote backends also prevent state file corruption and support locking mechanisms in a team environment.s



**Summary:**
- **Terraform Remote State Storage and Locking:** Used to manage and lock the state when stored remotely.
- **Terraform Remote State Datasource:** A way to reference remote state information in Terraform configurations.
- **Terraform State Commands:** Various commands to manipulate and inspect the Terraform state.
- **Terraform Refresh vs Plan:** `terraform refresh` updates the state file based on the current infrastructure, while `terraform plan` shows the proposed changes.
- **Terraform Workspaces with Local Backends and Remote Backends:** These are related to managing state in different environments or configurations.





