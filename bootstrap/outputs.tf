output "state_bucket_name" {
  description = "S3 bucket that stores Terraform state."
  value       = aws_s3_bucket.state.bucket
}

output "lock_table_name" {
  description = "DynamoDB table created for legacy Terraform state locking."
  value       = aws_dynamodb_table.terraform_locks.name
}

output "github_plan_role_arn" {
  description = "IAM role ARN used by GitHub Actions for Terraform plans"
  value       = aws_iam_role.github_plan.arn
}

output "github_apply_role_arn" {
  description = "IAM role ARN used by GitHub Actions for Terraform applies"
  value       = aws_iam_role.github_apply.arn
}

output "github_oidc_provider_arn" {
  description = "GitHub Actions OIDC provider ARN"
  value       = aws_iam_openid_connect_provider.github_actions.arn
}
