data "aws_iam_policy_document" "assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}


# Execution Role
resource "aws_iam_role" "exec" {
  name_prefix        = "${local.name}-exec-"
  assume_role_policy = data.aws_iam_policy_document.assume.json
}

resource "aws_iam_role_policy_attachment" "exec" {
  role       = aws_iam_role.exec.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "exec_shell" {
  statement {
    actions   = ["ecs:ExecuteCommand"]
    resources = ["arn:aws:ecs:${var.region}:${data.aws_caller_identity.current.account_id}:task/*"]
  }
}

# Task Role
resource "aws_iam_role" "task" {
  name_prefix        = "${local.name}-task-"
  assume_role_policy = data.aws_iam_policy_document.assume.json

}

resource "aws_iam_role_policy" "task_shell" {
  name   = "ECSShellAccess"
  role   = aws_iam_role.task.id
  policy = data.aws_iam_policy_document.task_shell.json
}

data "aws_iam_policy_document" "task_shell" {
  statement {
    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "task_logs" {
  name   = "ClouWatchLogGroup"
  role   = aws_iam_role.task.id
  policy = data.aws_iam_policy_document.task_logs.json
}

data "aws_iam_policy_document" "task_logs" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents",
    ]

    resources = ["arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:${var.cloudwatch_log_group}:*"]
  }
}
