variable "assume_role" {
  description = "The role TF assumes to manage resources on your behalf"
  type = string
}

variable "account_id" {
  description = "AWS account to deploy resources in"
  type = string # sometimes the account number strats with a zero
}

variable "vpc_cidr" {
  type = string
  default = "172.30.0.0/24"
}

variable "vpc_network_bits" {
  description = "Number of bits reserverd for networks in CIDR"
  type = number
  default = 3
}

variable "environment" {
  type    = string
  default = "demo"
}

variable "region" {
  type    = string
  default = "eu-west-2"
}

variable "container_tag" {
  type    = string
  default = "latest"
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
  type    = number
  default = 3
}

variable "max_scaling_count" {
  type    = number
  default = 10
}

variable "redis_node_type" {
  type    = string
  default = "cache.t4g.micro"
}

variable "redis_version" {
  type    = string
  default = "7.0"
}

variable "redis_parameter_family" {
  type = string
  default = "redis7"
}

variable "tags" {
  description = "A mapping of tags to assign to all resources"
  type        = map(string)
  default     = {}
}