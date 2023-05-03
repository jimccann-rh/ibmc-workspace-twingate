#dev-sts-uvm
#dev-lts-uvm

variable "aws_region" {
  default = "us-east-2"
}


variable "enviro" {
  type = map(object({
    tg_remote_network_id = string
    tg_subnet = string
    tg_security_group = list(string)
    aws_key = string
  }))
}


# example enivro vars
#  enviro = {
#    "dev-sts-uvm-1" = { tg_remote_network_id = "UNg==", tg_subnet = "subnet-074", tg_security_group = ["sg-07f"], aws_key = "development-sts" }
#    "dev-sts-uvm-2" = { tg_remote_network_id = "UNg==", tg_subnet = "subnet-074", tg_security_group = ["sg-07f"], aws_key = "development-sts" }
#    "dev-lts-uvm-1" = { tg_remote_network_id = "UMg==", tg_subnet = "subnet-039", tg_security_group = ["sg-0da"], aws_key = "development-lts" }
#    "dev-lts-uvm-2" = { tg_remote_network_id = "UMg==", tg_subnet = "subnet-039", tg_security_group = ["sg-0da"], aws_key = "development-lts" }
#  }







