module "ecs_fargate_cluster" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "5.11.4"

  cluster_name = var.cluster_name

  cluster_configuration = {
    execute_command_configuration = {
      logging = "OVERRIDE"
      log_configuration = {
        cloud_watch_log_group_name = var.cloudwatch_log_group
      }
    }
  }

  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 50
      }
    }
    FARGATE_SPOT = {
      default_capacity_provider_strategy = {
        weight = 50
      }
    }
  }
}

resource "aws_ecs_service" "service" {
  name            = local.service_name
  cluster         = module.ecs_fargate_cluster.cluster_arn
  launch_type     = "FARGATE"
  desired_count   = var.wordpress["desired_count"]
  task_definition = aws_ecs_task_definition.main.arn

  enable_execute_command            = true
  health_check_grace_period_seconds = 10

  network_configuration {
    subnets         = data.aws_subnet.private.*.id
    security_groups = [aws_security_group.ecs_wordpress.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.main.arn
    container_name   = "wordpress"
    container_port   = 80
  }
}

resource "aws_ecs_task_definition" "main" {
  family             = "wordpress"
  execution_role_arn = aws_iam_role.exec.arn
  task_role_arn      = aws_iam_role.task.arn
  network_mode       = "awsvpc"
  cpu                = var.wordpress["cpu"]
  memory             = var.wordpress["memory"]

  container_definitions = jsonencode([
    {
      name        = "wordpress"
      image       = "wordpress:latest"
      environment = local.environment
      essential   = true
      portMappings = [
        {
          containerPort = 80
          protocol      = "tcp"
          hostPort      = 80
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group        = var.cloudwatch_log_group
          awslogs-region           = var.region
          awslogs-stream-prefix = "${local.name}-wordpress"
        }
      }
    }
  ])

#   placement_constraints {
#     type       = "memberOf"
#     expression = "attribute:ecs.availability-zone in [us-east-1a, us-east-1b]"
#   }
}