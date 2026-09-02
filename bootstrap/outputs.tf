output "state_bucket_name" {
  description = "S3 bucket that stores Terraform state."
  value       = aws_s3_bucket.state.bucket
}

output "lock_table_name" {
  description = "DynamoDB table created for legacy Terraform state locking."
  value       = aws_dynamodb_table.terraform_locks.name
}