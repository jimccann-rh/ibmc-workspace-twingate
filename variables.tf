#dev-sts-uvm
#dev-lts-uvm

variable "aws_region" {
  default = "us-east-2"
}

locals {
  tfws = "${terraform.workspace}"
  enviro = {  
  }
}






