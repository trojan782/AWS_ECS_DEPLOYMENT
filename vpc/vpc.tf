module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "5.13.0"

  name = "${var.prefix}-vpc"
  cidr = var.cidr_block

  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  map_public_ip_on_launch = false

  enable_nat_gateway = true
  enable_dhcp_options = true
  one_nat_gateway_per_az = true

  nat_eip_tags = {
    "accessible" = "private"
  }

  igw_tags = {
    "Name" = "${var.prefix}-igw"
  }

  vpc_tags = {
    "Name" = "${var.prefix}-vpc"
  }

  public_subnet_tags = {
    "accessible" = "public"
  }

  private_subnet_tags = {
    "accessible" = "private"
  }

  ###########################################
#   route table tags should return the format of:
#   "staging-public-us-east-1"
  public_route_table_tags = {
    "Name"       = "${var.prefix}-public-${var.region}"
    "accessible" = "public"
  }

  private_route_table_tags = {
    "Name"       = "${var.prefix}-private-${var.region}"
    "accessible" = "private"
  }

  tags = {
    Terraform = "true"
    Environment = "staging"
  }
}