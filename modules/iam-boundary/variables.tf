variable "environment" {
  type        = string
  description = "Environment name (dev/prod)."
}

variable "aws_region" {
  type        = string
  description = "AWS region where workload resources are deployed."
}

variable "state_bucket_arn" {
  type        = string
  description = "ARN of the Terraform state S3 bucket."
}

variable "lock_table_arn" {
  type        = string
  description = "ARN of the Terraform state locking DynamoDB table."
}