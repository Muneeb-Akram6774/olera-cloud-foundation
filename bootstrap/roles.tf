data "aws_iam_policy_document" "github_plan_trust" {
  statement {
    effect = "Allow"

    principals {
      type = "Federated"

      identifiers = [
        aws_iam_openid_connect_provider.github_actions.arn
      ]
    }

    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"

      values = [
        "sts.amazonaws.com"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"

      values = [
        "repo:Muneeb-Akram6774/olera-cloud-foundation:pull_request"
      ]
    }
  }
}

resource "aws_iam_role" "github_plan" {
  name = "github-actions-terraform-plan"

  assume_role_policy = data.aws_iam_policy_document.github_plan_trust.json

  tags = {
    Project   = "olera-cloud-foundation"
    ManagedBy = "terraform"
    Purpose   = "github-actions-terraform-plan"
  }
}

resource "aws_iam_role_policy_attachment" "github_plan_read_only" {
  role = aws_iam_role.github_plan.name

  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}


/////////////// So The Apply Policy Starts Here, Doing this so I can remember later on ////////////////////

data "aws_iam_policy_document" "github_apply_trust" {
  statement {
    effect = "Allow"

    principals {
      type = "Federated"

      identifiers = [
        aws_iam_openid_connect_provider.github_actions.arn
      ]
    }

    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"

      values = [
        "sts.amazonaws.com"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"

      values = [
        "repo:Muneeb-Akram6774/olera-cloud-foundation:ref:refs/heads/main"
      ]
    }
  }
}

resource "aws_iam_role" "github_apply" {
  name = "github-actions-terraform-apply"

  assume_role_policy = data.aws_iam_policy_document.github_apply_trust.json

  tags = {
    Project   = "olera-cloud-foundation"
    ManagedBy = "terraform"
    Purpose   = "github-actions-terraform-apply"
  }
}

resource "aws_iam_role_policy_attachment" "github_apply_admin" {
  role = aws_iam_role.github_apply.name

  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}


//////// Now the Prod Policy ///////
data "aws_iam_policy_document" "github_prod_trust" {
  statement {
    effect = "Allow"

    principals {
      type = "Federated"

      identifiers = [
        aws_iam_openid_connect_provider.github_actions.arn
      ]
    }

    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"

      values = [
        "sts.amazonaws.com"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"

      values = [
        "repo:Muneeb-Akram6774/olera-cloud-foundation:environment:production"
      ]
    }
  }
}

resource "aws_iam_role" "github_prod" {
  name = "github-actions-terraform-apply-prod"

  assume_role_policy = data.aws_iam_policy_document.github_prod_trust.json

  tags = {
    Project     = "olera-cloud-foundation"
    ManagedBy   = "terraform"
    Purpose     = "github-actions-terraform-apply-prod"
    Environment = "production"
  }
}

resource "aws_iam_role_policy_attachment" "github_prod_admin" {
  role = aws_iam_role.github_prod.name

  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
