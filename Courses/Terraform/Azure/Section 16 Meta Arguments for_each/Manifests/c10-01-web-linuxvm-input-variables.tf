
variable "web_linuxvm_instance_details" {
  description = "Web Linux VM instance Count"
  type = map(string)
  default = {
    "vm-1" = "2022",
    "vm-2" = "3022",
    "vm-3" = "4022",
  }
}

