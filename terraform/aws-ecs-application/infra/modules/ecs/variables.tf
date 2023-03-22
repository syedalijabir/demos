variable "environment" {
  type    = string
  default = "staging"
}

variable "container_tag" {
  type    = string
  default = "latest"
}

variable "system" {
  type = string
}

variable "application_port" {
  type = string
}

variable "cpu" {
  type    = number
  default = 256
}

variable "memory" {
  type    = number
  default = 512
}

variable "min_scaling_count" {
  type = number
  default = 1
}

variable "max_scaling_count" {
  type = number
  default = 5
}

variable "redis_endpoint" {
  type = string
}

variable "redis_port" {
  type = string
}

variable "private_subnet_ids" {
  description = "List of Private VPC Subnet Ids"
  type        = list(string)
}

variable "lb_target_group_arn" {
  type = string
}

variable "ecs_security_group_id" {
  type = string
}

variable "tags" {
  description = "A mapping of tags to assign to all resources"
  type        = map(string)
}
