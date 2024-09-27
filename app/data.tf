data "aws_caller_identity" "current" {}

data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = ["${local.name}-vpc"]
  }
}

data "aws_subnet" "private" {
  count = length(var.azs)

  vpc_id = data.aws_vpc.main.id

  filter {
    name   = "tag:accessible"
    values = ["private"]
  }

  filter {
    name   = "tag:Name"
    values = ["jacops-vpc-private-${var.azs[count.index]}"]
  }
}

data "aws_subnet" "public" {
  count = length(var.azs)

  vpc_id = data.aws_vpc.main.id

  filter {
    name   = "tag:accessible"
    values = ["public"]
  }

  filter {
    name   = "tag:Name"
    values = ["jacops-vpc-public-${var.azs[count.index]}"]
  }
}