resource "aws_cloudwatch_log_group" "wordpress" {
  name = var.cloudwatch_log_group

  retention_in_days = "3"

}
