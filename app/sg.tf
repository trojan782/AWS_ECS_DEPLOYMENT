resource "aws_security_group" "alb" {
  name        = "${local.name}-sg-alb"
  vpc_id      = data.aws_vpc.main.id
  description = "ALB security group for ${local.name}"
}

resource "aws_vpc_security_group_ingress_rule" "alb_http_ingress" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 8080
  to_port           = 8080
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "alb_https_ingress" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "alb_egress" {
  security_group_id = aws_security_group.alb.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

############
# ECS/Wordpress SG
#########

resource "aws_security_group" "ecs_wordpress" {
  name        = "${local.name}-sg-ecs"
  vpc_id      = data.aws_vpc.main.id
  description = "Security group for ECS"
}

resource "aws_security_group_rule" "ecs_http_ingress" {
  type                     = "ingress"
  security_group_id        = aws_security_group.ecs_wordpress.id
  source_security_group_id = aws_security_group.alb.id
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  description              = "allow http traffic from the alb"
}

resource "aws_security_group_rule" "ecs_https_ingress" {
  type                     = "ingress"
  security_group_id        = aws_security_group.ecs_wordpress.id
  source_security_group_id = aws_security_group.alb.id
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  description              = "Allow https traffic from the alb"
}

resource "aws_security_group_rule" "ecs_egress" {
  type              = "egress"
  security_group_id = aws_security_group.ecs_wordpress.id
  cidr_blocks       = ["0.0.0.0/0"]
  protocol          = "-1" # All protocols
  from_port         = 0
  to_port           = 0
  description       = "Allow all egress traffic"
}

#################################################
# RDS Security Group 
resource "aws_security_group" "rds" {
  name        = "${local.name}-sg-rds"
  vpc_id      = data.aws_vpc.main.id
  description = "RDS security group"
}

resource "aws_security_group_rule" "rds_ingress" {
  type                     = "ingress"
  source_security_group_id = aws_security_group.ecs_wordpress.id
  security_group_id        = aws_security_group.rds.id
  protocol                 = "tcp"
  from_port                = 3306
  to_port                  = 3306
  description              = "Allow ingress traffic from the ECS SG to the DB"
}


resource "aws_vpc_security_group_egress_rule" "rds_egress" {
  security_group_id = aws_security_group.rds.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
  description       = "Allow all egress traffic"
}