variable "cluster_name" {
  type        = string
  description = "ECS cluster name"
}

variable "hosted_zone_id" {
  type = string
  description = "Hosted zone ID for r53"
}
# variable "capacity_provider" {
#   type = list(string)
#   description = "capacity provider for ECS"
# }

# variable "default_capacity_provider" {
#   type = string
#   description = "Default capacity provider"
# }

variable "container_insights_enabled" {
  type        = bool
  description = "Container insights"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "azs" {
  description = "A list of Availabilty Zones"
  default     = ["us-east-1a", "us-east-1b"]
  type        = list(string)
}

variable "rds" {
  description = "Map of variables used to provision RDS instance"
  type        = map(string)
}

variable "wordpress" {
  description = "Map of variables for wordpress"
  type        = map(number)
}

variable "rds_username" {
  description = "Username for RDS"
  type        = string
}

variable "rds_password" {
  description = "RDS db password"
  type        = string
}

variable "cloudwatch_log_group" {
  type        = string
  description = "Cloudwatch log group for wordpress"
}