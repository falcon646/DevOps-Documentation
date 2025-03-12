variable "web_lb_name" {
    description = "Name of the load balancer"
    type = string
    default = "web_lb"
}


# variable "web_lb_inbound_nat_ports" {
#     type = list(number)
#     default = [ 2022 , 3022 , 4022 , 5022 ]
# }