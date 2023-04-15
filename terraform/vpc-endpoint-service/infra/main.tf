module "ecs" {
  source = "./modules/ecs"

  container_tag         = var.container_tag
  application_port      = local.application_port
  cpu                   = var.cpu
  memory                = var.memory
  min_scaling_count     = var.min_scaling_count
  max_scaling_count     = var.max_scaling_count
  private_subnet_ids    = module.vpc_service.private_subnets
  ecs_security_group_id = aws_security_group.ecs_security_group.id
  lb_target_group_arn   = aws_lb_target_group.lb_target_group.arn
  system                = local.system
  environment           = var.environment

  tags = merge(
    local.common_tags,
    {
      name = "${local.system_key}-ecs"
    },
  )
}
