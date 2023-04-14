
resource "aws_ecs_service" "application" {
  name            = local.system_key
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  propagate_tags = "SERVICE"

  load_balancer {
    target_group_arn = var.lb_target_group_arn
    container_name   = var.system
    container_port   = var.application_port
  }

  network_configuration {
    subnets          = var.private_subnet_ids
    assign_public_ip = false
    security_groups = [
      var.ecs_security_group_id
    ]
  }

  lifecycle {
    ignore_changes = [
      desired_count
    ]
  }

  tags = merge(
    var.tags,
    {
      service-name = "${local.system_key}-ecs-service"
    },
  )
}

resource "aws_cloudwatch_log_group" "cw_log_group" {
  name              = "${local.system_key}-log-group"
  retention_in_days = 7
}

resource "aws_iam_role" "ecs_execution_role" {
  name = "${local.system_key}-execution-role"
  path = "/"

  assume_role_policy = templatefile("${path.module}/ecs_policies/assume_policy.json.tpl", {})
}

resource "aws_iam_role_policy" "ecs_policy" {
  role = aws_iam_role.ecs_execution_role.id
  policy = templatefile("${path.module}/ecs_policies/role_policy.json.tpl", {})
}

resource "aws_ecs_task_definition" "task_definition" {
  family = "${local.system_key}-task"

  network_mode = "awsvpc"
  cpu          = var.cpu
  memory       = var.memory

  requires_compatibilities = ["FARGATE"]

  execution_role_arn = aws_iam_role.ecs_execution_role.arn
  container_definitions = templatefile(
    "${path.module}/task_definitions/task_definition.json.tpl",
    {
      APP_PORT           = var.application_port
      AWSLOGS_GROUP_NAME = aws_cloudwatch_log_group.cw_log_group.name
      AWS_ACCOUNT_ID     = data.aws_caller_identity.current.account_id
      DOCKER_IMAGE       = "syedalijabir/simple-app"
      CONTAINER_NAME     = var.system
      CPU                = var.cpu
      MEMORY             = var.memory
      REDIS_ENDPOINT     = var.redis_endpoint
      REDIS_PORT         = var.redis_port
      REGION             = data.aws_region.current.name
    }
  )

  tags = merge(
    var.tags,
    {
      service-name = "${local.system_key}-task"
    },
  )
}
