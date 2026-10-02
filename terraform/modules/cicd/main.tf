resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]
}

data "aws_iam_policy_document" "github_assume_role" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    principals {
      type = "Federated"

      identifiers = [
        aws_iam_openid_connect_provider.github.arn
      ]
    }

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
        "repo:${var.github_owner}/${var.github_repo}:ref:refs/heads/main"
      ]
    }
  }
}

resource "aws_iam_role" "github_actions" {
  name = "${var.project_name}-${var.environment}-github-actions-role"

  assume_role_policy = data.aws_iam_policy_document.github_assume_role.json

  tags = {
    Name = "${var.project_name}-${var.environment}-github-actions-role"
  }
}

data "aws_iam_policy_document" "github_actions" {

  # Required for ECR authentication
  statement {
    sid    = "ECRAuthorization"
    effect = "Allow"

    actions = [
      "ecr:GetAuthorizationToken"
    ]

    resources = [
      "*"
    ]
  }

  # Push Docker images only to this repository
  statement {
    sid    = "ECRPush"
    effect = "Allow"

    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload"
    ]

    resources = [
      var.ecr_repository_arn
    ]
  }

  # Read current ECS task definition
  statement {
    sid    = "ECSRead"
    effect = "Allow"

    actions = [
      "ecs:DescribeTaskDefinition",
      "ecs:DescribeServices"
    ]

    resources = [
      "*"
    ]
  }

  # Register a new task definition revision
  statement {
    sid    = "ECSRegisterTaskDefinition"
    effect = "Allow"

    actions = [
      "ecs:RegisterTaskDefinition"
    ]

    resources = [
      "*"
    ]
  }

  # Deploy only to our ECS service
  statement {
    sid    = "ECSDeploy"
    effect = "Allow"

    actions = [
      "ecs:UpdateService"
    ]

    resources = [
      var.ecs_service_arn
    ]
  }

  # Required when GitHub registers a new task definition
  statement {
    sid    = "PassECSTaskRoles"
    effect = "Allow"

    actions = [
      "iam:PassRole"
    ]

    resources = [
      var.ecs_execution_role_arn
    ]
  }
}

resource "aws_iam_policy" "github_actions" {
  name = "${var.project_name}-${var.environment}-github-actions-policy"

  policy = data.aws_iam_policy_document.github_actions.json
}

resource "aws_iam_role_policy_attachment" "github_actions" {
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.github_actions.arn
}
