### Terraform Meta-Argument `count` Implementation for Azure Linux VM

#### Concepts Covered:
- Meta-Argument `count`
- Splat Expression
- `element` Function

#### Modifications Required:
1. **Update `azurerm_virtual_machine` Resource**  
   - Modify the resource to create multiple VM instances dynamically using `count` instead of defining separate resources.
   - This ensures that multiple identical Azure Linux VM instances are created using a single resource block.

2. **Load Balancer and Network Interface Association Updates**  
   - Update configurations to associate the NICs of the newly created VMs with the load balancer.

3. **Create Corresponding Network Interfaces**  
   - If five VMs are created, an equivalent number of network interfaces (NICs) must also be created.

4. **Update Inbound NAT Rules**  
   - Configure inbound NAT rules for all VM instances.

5. **Modify Output Variables**  
   - Adjust output variables to account for multiple VM instances.



### Step 1: Define Input Variables (`web-linuxvm-input-variables.tf`)

```hcl
variable "web_linuxvm_instance_count" {
  description = "Web Linux VM instance count"
  type        = number
  default     = 1
}

variable "web_lb_inbound_nat_ports" {
  description = "List of inbound NAT ports"
  type        = list(number)
  default     = [2022, 3022, 4022, 5022]
}
```

**Explanation:**
- `web_linuxvm_instance_count`: Defines the number of VM instances to create.
- `web_lb_inbound_nat_ports`: Specifies the list of ports for inbound NAT rules.



### Step 2: Define Values in `terraform.tfvars`

```hcl
web_linuxvm_instance_count = 4
web_lb_inbound_nat_ports   = [2022, 3022, 4022, 5022]
```

**Explanation:**
- Sets the actual number of VMs (`4` in this case).
- Assigns specific inbound NAT ports for each VM.



### Step 3: Implement `count` Meta-Argument (next video)

- The `count` meta-argument ensures multiple VM instances are created dynamically.
- The `element` function and splat expressions (`[*]`) manage indexed values dynamically.
- `depends_on` is used to handle explicit dependencies.

