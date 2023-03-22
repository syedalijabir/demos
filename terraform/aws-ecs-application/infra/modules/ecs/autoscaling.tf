resource "aws_iam_role" "autoscaling_role" {
  name = "${local.system_key}-autoscaling-role"
  path = "/"

  assume_role_policy = templatefile("${path.module}/ecs_policies/autoscaling_assume_policy.json.tpl", {})
}

resource "aws_iam_role_policy" "autoscaling_policy" {
  role = aws_iam_role.autoscaling_role.id
  policy = templatefile("${path.module}/ecs_policies/autoscaling_role_policy.json.tpl", {})
}

resource "aws_appautoscaling_target" "autoscaling_target" {
  depends_on = [
    aws_ecs_service.one_time_secrets
  ]
  max_capacity       = var.max_scaling_count
  min_capacity       = var.min_scaling_count
  resource_id        = "service/${aws_ecs_cluster.cluster.name}/${local.system_key}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
  role_arn           = aws_iam_role.autoscaling_role.arn
}

resource "aws_appautoscaling_policy" "autoscaling_target_cpu" {
  depends_on = [
    aws_appautoscaling_target.autoscaling_target
  ]

  name               = "${local.system_key}_cpu_scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.autoscaling_target.resource_id
  scalable_dimension = aws_appautoscaling_target.autoscaling_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.autoscaling_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value = 60
  }
}

resource "aws_appautoscaling_policy" "autoscaling_target_memory" {
  depends_on = [
    aws_appautoscaling_target.autoscaling_target
  ]

  name               = "${local.system_key}_memory_scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.autoscaling_target.resource_id
  scalable_dimension = aws_appautoscaling_target.autoscaling_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.autoscaling_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    target_value = 80
  }
}
