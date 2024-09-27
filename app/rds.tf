module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "6.9.0"

  identifier = var.rds["identifier"]

  manage_master_user_password = false

  engine            = var.rds["engine"]
  engine_version    = var.rds["auto_minor_version_upgrade"] ? var.rds["major_engine_version"] : var.rds["engine_version"]
  instance_class    = var.rds["instance_class"]
  allocated_storage = var.rds["allocated_storage"]

  db_name  = var.rds["db_name"]
  username = var.rds_username
  password = var.rds_password
  port     = 3306


  vpc_security_group_ids = [aws_security_group.rds.id]

  # DB subnet group
  db_subnet_group_name   = "jacops"
  create_db_subnet_group = true
  subnet_ids             = data.aws_subnet.private.*.id

  # DB parameter group
  family = "mysql5.7"

  # DB option group
  major_engine_version = var.rds["major_engine_version"]

  # Database Deletion Protection
  deletion_protection = false

  parameters = [
    {
      name  = "character_set_client"
      value = "utf8mb4"
    },
    {
      name  = "character_set_server"
      value = "utf8mb4"
    }
  ]
}