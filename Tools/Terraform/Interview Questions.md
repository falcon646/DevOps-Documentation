Below is a detailed set of answers to each interview question from the perspective of a seasoned Terraform engineer.

---

### 1. Daily activities that you do in Terraform?

On a daily basis, my work with Terraform involves a mix of development, collaboration, and operations. I start by reviewing any proposed changes submitted through our version control system. This involves reading pull requests to ensure that changes adhere to our coding standards, modular design, and security best practices. I then work on writing or refactoring Terraform configurations to improve efficiency and readability. 

In many cases, I spend time troubleshooting and resolving issues related to state management—ensuring that our remote backend (such as AWS S3 with DynamoDB for locking, Azure Blob Storage, or Terraform Cloud) is properly configured to prevent state corruption or concurrency issues. I frequently run commands like `terraform plan` to preview changes, and `terraform apply` to deploy infrastructure changes, while monitoring the output to catch any errors early.

Additionally, I collaborate with cross-functional teams to integrate Terraform into CI/CD pipelines. This involves scripting and automation (using tools like Jenkins, GitHub Actions, or GitLab CI) so that our infrastructure changes are automatically tested and deployed in a controlled environment. Overall, my daily activities are centered on ensuring that infrastructure as code remains robust, maintainable, and secure.

---

### 2. What are services that you have worked with and wrote terraform files?

Over the years, I have written Terraform configurations for a wide range of services across multiple cloud providers and platforms. In AWS, I have managed compute services such as EC2 and Lambda, networking resources like VPCs, subnets, security groups, and load balancers, as well as managed services such as RDS, DynamoDB, and S3. I have also implemented advanced security and monitoring configurations using IAM roles, policies, CloudWatch, and CloudTrail.

In Azure, I have provisioned virtual machines, scale sets, virtual networks, subnets, network security groups, and managed disks. I have also set up Azure Kubernetes Service (AKS), Azure SQL, and integrated Azure Key Vault for secure secret management. My experience extends to Google Cloud Platform, where I have automated the deployment of compute instances, managed Kubernetes clusters (GKE), and configured networking components like VPCs and firewall rules.

Beyond the cloud providers, I have also used Terraform to manage Kubernetes resources directly and integrate with configuration management tools, as well as third-party services like Datadog, PagerDuty, and even legacy systems that expose API endpoints. This diverse experience has honed my ability to architect scalable and secure infrastructure solutions using Terraform.

---

### 3. Tell me a scenario where you come across provisioners?

Provisioners in Terraform are generally used as a last resort when post-provisioning configuration is necessary. I recall a scenario where I needed to bootstrap an Azure Virtual Machine with a custom software package that was not available in the standard repositories. Although the preferred approach is to use cloud-init or configuration management tools like Ansible, in this case the requirement was to execute a one-time script immediately after the resource was created.

I implemented a `remote-exec` provisioner within the VM resource definition. The provisioner connected via SSH to the VM and executed a shell script that installed and configured the software, adjusted firewall settings, and performed system updates. It was critical to handle errors gracefully and log outputs for troubleshooting. While this approach worked, it reinforced the lesson that provisioners should be used sparingly and only when no other automated configuration method is available.

---

### 4.  What are plugins and providers in terraform?

In Terraform, providers are a specific type of plugin that acts as an interface to various APIs of cloud platforms, SaaS providers, and other services. Each provider is responsible for understanding the API interactions required to manage resources for that service. For example, the AWS provider translates Terraform configurations into API calls to create, update, or delete resources like EC2 instances, S3 buckets, and IAM roles.

Plugins, in a broader sense, are binary components that extend Terraform’s functionality. Providers are one of the most common plugin types, but there are also provisioners, state backends, and other extensions that follow the same plugin architecture. The provider model allows Terraform to remain highly extensible, enabling developers to add support for new services without modifying the core engine. This plugin architecture is central to Terraform’s flexibility and its ability to serve as a unified tool for infrastructure management across diverse environments.

---

### 5. How do you deploy the terraform code ? manually or with some automation ? Have configured locks on the backend statefile?

Deployment of Terraform code can be performed both manually and through automated pipelines. In a manual scenario, I typically start by running `terraform init` to initialize the working directory, followed by `terraform plan` to review the planned changes. After ensuring that the plan aligns with the intended changes, I execute `terraform apply` to deploy the infrastructure.

For automation, I integrate Terraform into CI/CD pipelines using tools like Jenkins, GitHub Actions, or Terraform Cloud. These pipelines execute the same commands, often incorporating additional steps such as linting, formatting checks, and automated testing to ensure that the configuration meets our standards before deployment.

State locking is a critical component of safe Terraform deployments. In multi-user environments, I configure remote backends with built-in locking mechanisms (for example, using DynamoDB for AWS or Azure Blob Storage with lease locking). This prevents concurrent runs that might lead to race conditions or state file corruption. By enforcing locks, we ensure that only one operation modifies the state at a time, which is essential for maintaining infrastructure integrity.

---

### 6. When you want to deploy the same terraform code on different env then what is the best strategy?

When deploying Terraform code across multiple environments such as development, staging, and production, the best strategy is to use a combination of workspaces and environment-specific variable files. Terraform workspaces allow for multiple state files to be maintained within the same configuration, ensuring that resources in one environment do not conflict with those in another.

Alternatively, some teams prefer to separate environments into distinct directories with their own state backends. This approach makes the boundaries between environments explicit and can simplify access control and auditing. Using environment-specific variable files (for example, `dev.tfvars`, `staging.tfvars`, and `prod.tfvars`) ensures that configuration differences are managed systematically. This strategy also allows for differences in resource sizes, region selections, and other environment-specific parameters without duplicating the core infrastructure code.

---

### 7. How do you standardize terraform code so that can be shared across multiple teams in an organization?

To share Terraform code across multiple teams in an organization, standardization is key. I follow a modular approach where common infrastructure components are encapsulated within reusable modules. These modules are stored in version-controlled repositories and adhere to a set of best practices and naming conventions. 

In addition to modules, I enforce coding standards using tools such as TFLint, terraform fmt, and pre-commit hooks. Documentation is critical, so I maintain comprehensive READMEs and usage examples for each module. For large organizations, adopting an internal Terraform registry can further streamline the sharing process by making modules discoverable and version-controlled. This approach promotes reusability, consistency, and a single source of truth for infrastructure as code, reducing duplication and ensuring that best practices are consistently applied.

---

### 8. How do you call output of one module in another module?

Terraform modules are designed to be loosely coupled, and one of the main ways to share data between modules is through outputs. When a module produces an output, it can be referenced by other modules in the root module configuration. For example, if a network module outputs a subnet ID, that output can be passed as an input variable to a compute module.

The process is straightforward: first, define the output in the source module using an `output` block. Then, in the parent module, capture that output by referencing the module call (e.g., `module.network.subnet_id`) and pass it to the child module via its input variable. This pattern encourages modular design and clean separation of responsibilities while enabling dependencies between different parts of the infrastructure.

---

### 9. Lets say you have created lot of resources using terraform.  Is there way to delete one of the resource through Terraform?

Terraform is designed to manage entire sets of resources declared in its configuration, so it does not provide a direct command to delete a single resource while leaving the rest of the configuration untouched. However, there are a couple of approaches to effectively remove a resource.

One method is to remove the resource block from the Terraform configuration and then run `terraform apply`. Terraform will detect that the resource is no longer part of the configuration and will plan to destroy it. If the resource needs to be removed from state without actually destroying the physical resource, the command `terraform state rm` can be used. This command detaches the resource from Terraform’s state, making Terraform "forget" about it. However, note that this does not delete the resource itself; it simply removes it from management. In practice, careful planning and documentation are necessary when removing resources to avoid unintended consequences.

---

### 10. Can we merge 2 different state files ?

Merging two different Terraform state files is not a straightforward task and is generally considered risky. The state file is a critical representation of your deployed infrastructure, and merging state files manually can lead to inconsistencies if not done carefully.

In scenarios where merging state is required, one common approach is to use `terraform state pull` to retrieve the current state and then carefully merge the JSON representations of the state files. Another strategy involves using `terraform import` to import resources from one state file into the configuration managed by another state file. This method requires careful planning and testing in a non-production environment to ensure that the resulting state accurately represents the infrastructure.

It is generally advisable to avoid merging state files by designing the infrastructure architecture in a way that each component or environment is managed with a separate state backend from the outset. This proactive design minimizes the need for such operations and reduces the risk of state corruption.

---

### 11. Can you add an existing resource created manually on cloud to be managed by terraform ? 

Yes, it is possible to bring an existing manually created resource under Terraform management, but the process requires careful planning and execution. The primary method for doing this is by using the "terraform import" command. This command allows Terraform to read the current state of the resource from the cloud provider and incorporate that state into its state file, which is how Terraform keeps track of managed resources.

The process begins by writing the appropriate resource block in your Terraform configuration files. This block must mirror the existing resource’s configuration as accurately as possible. Since Terraform import only updates the state file and does not generate configuration code, you must manually define all the attributes in your code that correspond to the current settings of the resource. This step is critical because any discrepancy between the resource’s actual configuration and your Terraform configuration may lead to unexpected changes when you run "terraform plan" or "terraform apply."

Once you have your configuration in place, you run the "terraform import" command with the correct resource address and the unique identifier of the resource as defined by your cloud provider. Terraform then retrieves the current configuration of the resource and writes it into its state file. After the import, it is advisable to run "terraform plan" to confirm that Terraform’s view of the resource aligns with its actual state. If Terraform detects differences, you may need to adjust your configuration files to accurately reflect the existing settings, thus preventing any unintended modifications during subsequent deployments.

This approach allows you to integrate legacy or manually provisioned resources into your infrastructure as code workflow, providing benefits such as version control, reproducibility, and a centralized management strategy. However, it is important to note that once the resource is imported, all future modifications should be made through Terraform to avoid state drift or discrepancies between the resource’s actual state and the Terraform state file. The adoption process can be somewhat challenging, especially when dealing with complex resources, so thorough documentation and testing in a non-production environment are recommended before rolling the changes out in production.