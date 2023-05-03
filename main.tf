terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    twingate = {
      source = "twingate/twingate"
    }
  }
}

variable "AWS_ACCESS_KEY_ID" {}
variable "AWS_SECRET_ACCESS_KEY" {}
variable "tg_api_key" {}
variable "tg_network" {}
variable "tg_owner" {}
variable "tg_enviro" {}

# Configure the AWS Provider
  provider "aws" {
  region     = var.aws_region 
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
}


# Configure Twingate Provider
  provider "twingate" {
  api_token = var.tg_api_key
  network   = var.tg_network
}

#Twingate AMI
data "aws_ami" "twingate" {
  most_recent = true

  filter {
    name   = "name"
    values = ["twingate/images/hvm-ssd/twingate-amd64-*"]
  }

  owners = [var.tg_owner] # Twingate
}



resource "twingate_connector" "tg_connector" {
  for_each = var.tg_enviro
  remote_network_id = each.value.tg_remote_network_id
}

resource "twingate_connector_tokens" "aws_connector_tokens" {
  for_each = var.tg_enviro
  connector_id = twingate_connector.tg_connector[each.key].id
}

resource "aws_instance" "twingate_connector" {
  lifecycle {
    create_before_destroy = true
  }
  for_each = var.tg_enviro
  ami           = data.aws_ami.twingate.id
  instance_type = "t3.micro"
  associate_public_ip_address = false
  key_name = each.value.aws_key

  user_data = <<-EOT
    #!/bin/bash
    set -e
    mkdir -p /etc/twingate/
    {
      echo TWINGATE_URL="https://${var.tg_network}.twingate.com"
      echo TWINGATE_ACCESS_TOKEN="${twingate_connector_tokens.aws_connector_tokens[each.key].access_token}"
      echo TWINGATE_REFRESH_TOKEN="${twingate_connector_tokens.aws_connector_tokens[each.key].refresh_token}"
    } > /etc/twingate/connector.conf
    sudo systemctl enable --now twingate-connector
  EOT

  subnet_id              = each.value.tg_subnet
  vpc_security_group_ids = each.value.tg_security_group

  tags = {
    "Name" = "twingate-${twingate_connector.tg_connector[each.key].name}"
  }
}
