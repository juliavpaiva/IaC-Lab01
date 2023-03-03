variable "instance_type" {
  type = string
}

variable "amis" {

  default = {
    "eu-west-1" = "ami-065793e81b1869261"
    "eu-west-2" = "ami-086b3de06dafe36c5"
  }
}

data "aws_region" "current" {}

data "aws_availability_zones" "available" {}