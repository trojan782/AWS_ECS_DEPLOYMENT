cluster_name = "cluster_name"

cloudwatch_log_group = "/ECS/app/wordpress"

hosted_zone_id = "your_hosted_zone_id"
domain_name    = "blog.example.com" #replace with your domain

capacity_provider          = ["FARGATE", "FARGATE_SPOT"]
default_capacity_provider  = "FARGATE"
container_insights_enabled = true

rds = {
  identifier                 = "staging-db"
  instance_class             = "db.t3.micro"
  engine                     = "mysql"
  major_engine_version       = "5.7"
  allocated_storage          = 10
  db_name                    = "demo"
  auto_minor_version_upgrade = true
}

wordpress = {
  cpu           = 256
  memory        = 512
  desired_count = 2
}

rds_username = "testuser"
rds_password = "testpassword"
