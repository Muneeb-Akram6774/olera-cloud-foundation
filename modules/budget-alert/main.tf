data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "budget_sns" {
  statement {
    sid    = "AllowAwsBudgetsToPublish"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["budgets.amazonaws.com"]
    }

    actions = [
      "SNS:Publish"
    ]

    resources = [
      aws_sns_topic.budget_alerts.arn
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"

      values = [
        data.aws_caller_identity.current.account_id
      ]
    }

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"

      values = [
        "arn:aws:budgets::${data.aws_caller_identity.current.account_id}:*"
      ]
    }
  }
}

resource "aws_sns_topic_policy" "budget_alerts" {
  arn = aws_sns_topic.budget_alerts.arn

  policy = data.aws_iam_policy_document.budget_sns.json
}


resource "aws_sns_topic" "budget_alerts" {
  name = "olera-${var.environment}-budget-alerts"

  tags = {
    Project     = "olera-cloud-foundation"
    Environment = var.environment
    ManagedBy   = "terraform"
    Tier        = "security"
  }
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.budget_alerts.arn
  protocol  = "email"
  endpoint  = var.notification_email
}

resource "aws_budgets_budget" "monthly" {
  name         = "olera-${var.environment}-monthly-budget"
  budget_type  = "COST"
  limit_amount = tostring(var.budget_amount)
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  notification {
    comparison_operator       = "GREATER_THAN"
    threshold                 = 80
    threshold_type            = "PERCENTAGE"
    notification_type         = "ACTUAL"
    subscriber_sns_topic_arns = [aws_sns_topic.budget_alerts.arn]
  }

  notification {
    comparison_operator       = "GREATER_THAN"
    threshold                 = 100
    threshold_type            = "PERCENTAGE"
    notification_type         = "ACTUAL"
    subscriber_sns_topic_arns = [aws_sns_topic.budget_alerts.arn]
  }

  tags = {
    Project     = "olera-cloud-foundation"
    Environment = var.environment
    ManagedBy   = "terraform"
    Tier        = "security"
  }
}