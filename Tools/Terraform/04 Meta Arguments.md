### **Meta-Arguments in Terraform**
Meta-arguments in Terraform are special arguments that **modify** how resources and modules behave. They **do not** directly configure the resource itself but instead control **how Terraform manages it**.



## **1. count**
- Used to **create multiple instances** of a resource dynamically.
- Example: Creating 3 EC2 instances in AWS.
  
  ```hcl
  resource "aws_instance" "example" {
    count         = 3
    ami           = "ami-12345678"
    instance_type = "t2.micro"
  }
  ```
- `count.index` can be used inside the resource to differentiate each instance.



## **2. for_each**
- Used when creating multiple resources **from a list or map**, offering more flexibility than `count`.
- Example: Creating multiple Azure VMs using a map.
  
  ```hcl
  resource "azurerm_virtual_machine" "example" {
    for_each = {
      "vm1" = "Standard_DS1_v2"
      "vm2" = "Standard_B2s"
    }
    
    name           = each.key
    vm_size       = each.value
    resource_group_name = "my-rg"
  }
  ```
- **Difference from `count`**:  
  - `for_each` works with **maps and sets**, while `count` only works with **numbers**.



## **3. depends_on**
- Ensures that a resource is created **only after another resource is fully created**.
- Example: An Azure VM should be created **only after the network interface is ready**.

  ```hcl
  resource "azurerm_network_interface" "example" {
    name                = "example-nic"
    resource_group_name = "my-rg"
  }

  resource "azurerm_virtual_machine" "example" {
    name              = "example-vm"
    depends_on        = [azurerm_network_interface.example]
    resource_group_name = "my-rg"
  }
  ```



## **4. lifecycle**
- Controls **how Terraform handles resource updates and deletions**.
- Common options:
  - `create_before_destroy`: Creates a new resource before destroying the old one.
  - `prevent_destroy`: Prevents accidental resource deletion.
  - `ignore_changes`: Ignores changes to specific attributes.

  **Example: Preventing accidental deletion of an S3 bucket**
  ```hcl
  resource "aws_s3_bucket" "example" {
    bucket = "my-terraform-bucket"

    lifecycle {
      prevent_destroy = true
    }
  }
  ```



## **5. provider**
- Allows specifying **which provider configuration** a resource should use.
- Useful when managing multiple cloud accounts or regions.

  ```hcl
  provider "aws" {
    alias = "us-east"
    region = "us-east-1"
  }

  provider "aws" {
    alias = "us-west"
    region = "us-west-2"
  }

  resource "aws_instance" "example" {
    provider = aws.us-west
    ami      = "ami-12345678"
  }
  ```



## **6. module**
- Used to define and reuse Terraform **modules**.
- Example: Using a module for VMs.
  
  ```hcl
  module "vm" {
    source = "./modules/virtual-machine"
    vm_name = "web-server"
  }
  ```

