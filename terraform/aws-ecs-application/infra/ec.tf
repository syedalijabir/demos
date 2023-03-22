resource "aws_elasticache_cluster" "ec" {
  cluster_id           = "${local.system_key}-ec"
  engine               = "redis"
  node_type            = var.redis_node_type
  engine_version       = var.redis_version
  num_cache_nodes      = 1
  parameter_group_name = aws_elasticache_parameter_group.parameter_group.name
  port                 = local.redis_port
  security_group_ids   = [aws_security_group.ec_security_group.id]
  subnet_group_name    = aws_elasticache_subnet_group.subnet_group.name
}

resource "aws_elasticache_subnet_group" "subnet_group" {
  name        = "${local.system_key}-ec-subnet-group"
  description = "${local.system_key}-ec-subnet-group Elasticache Cluster Subnet Group"
  subnet_ids  = module.vpc.private_subnets
}

resource "aws_elasticache_parameter_group" "parameter_group" {
  name   = "${local.system_key}-ec-parameter-group"
  family = var.redis_parameter_family
  parameter {
    name  = "cluster-enabled"
    value = "no"
  }
}