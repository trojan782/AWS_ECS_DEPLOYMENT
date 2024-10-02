output "alb_dns_name" {
  value = aws_lb.main.dns_name
}

output "ecs_cluster_name" {
    value = module.ecs_fargate_cluster.cluster_name
}
output "alb_arn" {
  value = aws_lb.main.arn
}