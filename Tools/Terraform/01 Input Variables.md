# **Terraform Input Variables**  
Terraform **input variables** allow users to parameterize configurations, making them dynamic and reusable. Instead of hardcoding values, input variables enable passing values at runtime.

- **Declaring an Input Variable**   : Variables are declared using the `variable` block in a `.tf` file, usually named `variables.tf`:  
    ```hcl
    variable "instance_type" {
        description = "Type of EC2 instance"
        type        = string
        default     = "t2.micro"
    }
    ```
    - **`description`** → (Optional) Explains the purpose of the variable.  
    - **`type`** → Defines the data type (`string`, `number`, `bool`, `list`, `map`, `set`, `object`, `tuple`, etc.).  
    - **`default`** → (Optional) Provides a default value if none is given.  

- **Using Input Variables in Terraform Configuration**   : After declaring a variable, it can be referenced using `"var.<variable_name>"`:  
    ```hcl
    resource "aws_instance" "example" {
        instance_type = var.instance_type
        ami           = "ami-0abcdef1234567890"
    }
    ```
- **Assigning Values to Variables**  : There are multiple ways to assign values to Terraform variables:
    - **Using `-var` in CLI**
        ```sh
        terraform apply -var="instance_type=t3.micro"
        ```
    - **Using `.tfvars` File**  : Create a `terraform.tfvars` file:
        ```hcl
        instance_type = "t3.micro"
        ```
        - Terraform automatically loads this file.
    - **Using Environment Variables**
        ```sh
        export TF_VAR_instance_type="t3.micro"
        terraform apply
        ```
    - **Using `terraform.tfvars.json` File**  
        ```json
        {
        "instance_type": "t3.micro"
        }
        ```


### **Input Validation (Terraform 0.13+)**  
Validation ensures only valid values are provided:  
```hcl
variable "instance_type" {
  type = string

  validation {
    condition     = contains(["t2.micro", "t3.micro"], var.instance_type)
    error_message = "Allowed values: t2.micro, t3.micro."
  }
}
```

### **Sensitive Variables**  
Terraform allows marking variables as **sensitive** to hide them in logs:  
```hcl
variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}
```

### **Variable Types**  
Terraform supports several data types:
- String
- Number
- Boolean
- List
- Map
- Set
-  Object
- Tuple

**Syntax and Uasage**

- ### **1. String**  
    ```sh
    # declaration
    variable "region" {
        type = string
    }

    # Usage
    region = var.region
    ```

- ### **2. Number**  
    ```sh
    # declaration
    variable "instance_count" {
        type = number
    }

    # Usage
    count = var.instance_count
    ```

- ### **3. Boolean**  
    ```sh
    # declaration
    variable "enable_monitoring" {
        type = bool
        default = true
    }

    # Usage
    monitoring = var.enable_monitoring
    ```

- #### **4. List** `list(type)`
    - A list is an ordered collection of values where each element must be of the same type.
        - Declared as `list(<type>)`, where `<type>` is string, number, or bool.
        - Elements are indexed starting from 0.
        - Can contain duplicates.
            ```hcl
            variable "allowed_ports" {
                type = list(number)
                default = [80, 443, 22]
            }
            ```
            - **Accessing List Elements**
            ```sh
            ingress {
                from_port = var.allowed_ports[0]
            }
            ```
            - **Dynamic Iteration Over Lists (using `for` Expression)**
            ```sh
            resource "aws_security_group" "example" {
                ingress = [
                    for port in var.allowed_ports : {
                        from_port = port
                        to_port   = port
                        protocol  = "tcp"
                    }
                ]
            }
            ```
- #### **5. Map** ` map(type)`
    - A map is a collection of key-value pairs, where all values must be of the same type.
        - Declared as map(<type>), where <type> can be string, number, or bool.
        - Keys are unique and must be strings.
        - Values must be of the declared type.
            ```sh
            variable "instance_ami" {
                type = map(string)
                default = {
                    us-east-1 = "ami-12345"
                    us-west-2 = "ami-67890"
                }
            }
            ```
        - **Accessing Map Elements**
            ```hcl
            ami = var.instance_ami["us-east-1"] # Returns "ami-123456"
            ```
        - **Iterating Over a Map**
            ```sh
            output "region_amis" {
                value = { for region, ami in var.ami_ids : region => ami }
            }

- #### **6. Set**  `set(type)`
    - A set is an unordered collection of unique values, meaning duplicates are not allowed.
        - Declared as set(<type>), where <type> can be string, number, or bool.
        - Elements are not ordered (unlike lists).
        - Cannot contain duplicates.
        - A `set` is an unordered collection of unique values.  
        ```hcl
        variable "allowed_cidrs" {
            type = set(string)
            default = ["10.0.0.0/16", "192.168.1.0/24"]
        }
        ```
        - **Accesing Set Elements**
        ```sh
        resource "aws_security_group_rule" "ingress" {
        for_each   = var.allowed_cidrs
        cidr_block = each.value
        }
        ```

- #### **7. Object**   `object({ ... })`
    - An object is a structured collection of multiple attributes with different data types.
        - Declared as object({ key1 = type1, key2 = type2, ... }).
        - Each attribute must match its declared type.
        - Can have nested objects inside. 
        ```hcl
        variable "server_config" {
            type = object({
                instance_type = string
                disk_size     = number
                enable_logs   = bool
            })

            default = {
                instance_type = "t3.medium"
                disk_size     = 100
                enable_logs   = true
            }
        }
        ```
        - **Accesing Object Elements**
        ```sh
        resource "aws_instance" "example" {
            instance_type = var.server_config.instance_type
            root_block_device {
                volume_size = var.server_config.disk_size
            }
        }
        ```
    - **Nested Object**
    ```sh
    variable "network_config" {
        type = object({
            vpc_id   = string
            subnets  = list(string)
            security = object({
                allow_ssh = bool
                allow_http = bool
            })
        })
        default = {
            vpc_id   = "vpc-12345"
            subnets  = ["subnet-11111", "subnet-22222"]
            security = {
                allow_ssh  = true
                allow_http = false
            }
        }
    }
    ```

- ### **8. Tuple**  
    - A tuple is a fixed-length list where elements can be of different types.
        - Declared as tuple([type1, type2, ...]).
        - Elements must be in the declared order.
        - Index-based access is required.
```hcl
variable "app_settings" {
  type = tuple([string, number, bool])
  default = ["prod", 3, true]
}
```
Usage:
```hcl
environment = var.app_settings[0]  # "prod"
replicas    = var.app_settings[1]  # 3
logging     = var.app_settings[2]  # true
```

