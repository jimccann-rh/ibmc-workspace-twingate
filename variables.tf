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









