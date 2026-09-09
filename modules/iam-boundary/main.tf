data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "boundary" {
  statement {
    sid    = "AllowInfrastructureServices"
    effect = "Allow"

    actions = [
      "ec2:*",
      "elasticloadbalancing:*",
      "autoscaling:*",
      "s3:*",
      "dynamodb:*",
      "logs:*",
      "cloudwatch:*"
    ]

    resources = ["*"]
  }

  statement {
    sid    = "DenyTerraformStateDeletion"
    effect = "Deny"

    actions = [
      "s3:DeleteBucket"
    ]

    resources = [
      var.state_bucket_arn
    ]
  }

  statement {
    sid    = "DenyTerraformLockTableDeletion"
    effect = "Deny"

    actions = [
      "dynamodb:DeleteTable"
    ]

    resources = [
      var.lock_table_arn
    ]
  }

  statement {
    sid    = "DenyIamPrivilegeEscalation"
    effect = "Deny"

    actions = [
      "iam:CreatePolicy",
      "iam:CreateUser",
      "iam:CreateRole",
      "iam:AttachUserPolicy",
      "iam:AttachRolePolicy",
      "iam:PutUserPolicy",
      "iam:PutRolePolicy"
    ]

    resources = ["*"]
  }

  statement {
    sid    = "DenyUnapprovedRegions"
    effect = "Deny"

    not_actions = [
      "iam:*",
      "route53:*",
      "cloudfront:*",
      "support:*"
    ]

    resources = ["*"]

    condition {
      test     = "StringNotEquals"
      variable = "aws:RequestedRegion"

      values = [
        var.aws_region
      ]
    }
  }
}

resource "aws_iam_policy" "boundary" {
  name        = "olera-${var.environment}-infrastructure-boundary"
  description = "Permissions boundary for Olera infrastructure operators."

  policy = data.aws_iam_policy_document.boundary.json

  tags = {
    Project     = "olera-cloud-foundation"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

resource "aws_iam_role" "infrastructure_operator" {
  name = "olera-${var.environment}-infrastructure-operator"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = data.aws_caller_identity.current.account_id
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  permissions_boundary = aws_iam_policy.boundary.arn

  tags = {
    Project     = "olera-cloud-foundation"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}