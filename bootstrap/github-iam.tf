data "aws_iam_policy_document" "github_plan_trust" {
  statement {
    effect = "Allow"

    principals {
      type = "Federated"

      identifiers = [aws_iam_openid_connect_provider.github_actions.arn]
    }

    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringEquals"
      variable = "tokens.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"

      values = ["repo:Muneeb-Akram6774@221060367/olera-cloud-foundation@1340176981:pull_request"]
    }
  }

}

resource "aws_iam_role" "github_plan" {
  name = "github-actions-terraform-plan"

  assume_role_policy = data.aws_iam_policy_document.github_plan_trust.json

}

resource "aws_iam_role_policy_attachment" "github_plan_read_only" {
  role       = aws_iam_role.github_plan.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"

}


/////////////////// Now we have GitHub Apply Policy Below ////////////////

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
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"

      values = [
        "repo:Muneeb-Akram6774@221060367/olera-cloud-foundation@1340176981:ref:refs/heads/main"
      ]
    }
  }
}

resource "aws_iam_role" "github_apply" {
  name = "github-actions-terraform-apply"

  assume_role_policy = data.aws_iam_policy_document.github_apply_trust.json
}

resource "aws_iam_role_policy_attachment" "github_apply_admin" {
  role       = aws_iam_role.github_apply.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
