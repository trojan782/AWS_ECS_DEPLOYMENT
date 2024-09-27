locals {
  name         = "jacops"
  service_name = "wordpress"

  environment = [
    {
      name  = "WORDPRESS_DB_HOST"
      value = module.rds.db_instance_address
    },
    {
      name  = "WORDPRESS_DB_USER"
      value = var.rds_username
    },
    {
      name  = "WORDPRESS_DB_PASSWORD"
      value = var.rds_password
    },
    {
      name  = "WORDPRESS_DB_NAME"
      value = var.rds["db_name"]
    }
  ]
}
