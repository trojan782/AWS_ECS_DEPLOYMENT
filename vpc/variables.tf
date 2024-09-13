variable "region" {
  description = "AWS region to be used"
  default = "us-east-1"
  type = string
}
variable "prefix" {
  description = "The environment prefix"
  type = string
}

variable "name" {
  type = string
  description = "Name of VPC"
  default = "wp_ecs"
}

variable "cidr_block" {
    type = string
    description = "CIDR block for VPC"
    default = "10.0.0.0/16"
}

variable "azs" {
  type = list(string)
  description = "Avalibility Zones"
  default = [ "us-east-1a", "us-east-1b" ]
}

variable "private_subnets" {
    type = list(string)
    description = "CIDR for private subnets"
    default = [ "10.0.1.0/24", "10.0.2.0/24" ]
}

variable "public_subnets" {
    type = list(string)
    description = "CIDR for public subnets"
    default = [ "10.0.8.0/24", "10.0.3.0/24" ]
}