**Azure Virtual Network Design (Step 6)**: In the current step, the focus is on designing an Azure Virtual Network (VNet). The following elements will be configured:
   - **Subnets**: Web, App, DB, and Bastion subnets.
   - **Network Security Groups (NSGs)**: These NSGs will be created and associated with the respective subnets.
**Output Values**: Output values will be used to retrieve and display important information related to the virtual network.

**Terraform Meta-arguments**:
   - **`depends_on`**: This meta-argument will be used to specify dependencies between resources, ensuring resources are created in the correct order.
   - **`for_each`**: This meta-argument allows creating multiple instances of resources dynamically based on a given collection.
