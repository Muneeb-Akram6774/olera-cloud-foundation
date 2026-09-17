output "state_bucket_name" {
  description = "S3 bucket that stores Terraform state."
  value       = aws_s3_bucket.state.bucket
}

output "lock_table_name" {
  description = "DynamoDB table created for legacy Terraform state locking."
  value       = aws_dynamodb_table.terraform_locks.name
}

output "github_plan_role_arn" {
  value = aws_iam_role.github_plan.arn
}

output "github_apply_role_arn" {
  value = aws_iam_role.github_apply.arn
}

output "github_prod_role_arn" {
  value = aws_iam_role.github_prod.arn
}

output "github_oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.github_actions.arn
}
