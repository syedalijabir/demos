variable "assume_role" {
  description = "The role TF assumes to manage resources on your behalf"
  type = string
}

variable "account_id" {
  description = "AWS account to deploy resources in"
  type = string # sometimes the account number strats with a zero
}