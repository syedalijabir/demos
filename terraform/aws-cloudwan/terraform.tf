terraform {
  required_version = "~> 1.0"
  backend "s3" {
    bucket   = "<tf_backend_bucket_name>"
    key      = "<tf_backend_bucket_prefix>"
    region   = "<tf_backend_bucket_region>"
    role_arn = "arn:aws:iam::<tf_backend_account_id>:role/<tf_access_role>"
  }
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.59.0"
    }
  }
}
