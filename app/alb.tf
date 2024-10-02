resource "aws_lb" "main" {
  name               = "${local.name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = [for subnet in data.aws_subnet.public : subnet.id]

  enable_deletion_protection = false
  drop_invalid_header_fields = true

  tags = {
    Environment = "staging"
  }
}

resource "aws_lb_target_group" "main" {
  name                 = "${local.name}-tg"
  port                 = 80
  protocol             = "HTTP"
  slow_start           = 0
  target_type          = "ip"
  vpc_id               = data.aws_vpc.main.id
  deregistration_delay = 10

  health_check {
    path                = "/"
    port                = 80
    matcher             = "200-399"
    timeout             = 5
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 5
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.main.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}
