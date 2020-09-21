variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "eu-west-2"
}

data "aws_vpc" "currentvpc" {
    default = true
}

data "aws_ami" "ubuntu" {
    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"] # Canonical
}
 