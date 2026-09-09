output "boundary_policy_arn" {
  description = "ARN of the infrastructure operator permissions boundary."
  value       = aws_iam_policy.boundary.arn
}

output "infrastructure_operator_role_arn" {
  description = "ARN of the infrastructure operator IAM role."
  value       = aws_iam_role.infrastructure_operator.arn
}