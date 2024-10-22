####################
# ECS で利用する IAM ロールとポリシーを作成する
####################

# ECR からイメージを取得するためのポリシー
data "aws_iam_policy_document" "pull_ecr_image" {
  // see: https://docs.aws.amazon.com/AmazonECR/latest/userguide/ECR_on_ECS.html
  statement {
    effect = "Allow"

    sid = "PullImagesFromECR"

    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "pull_ecr_image" {
  name        = "pull_ecr_image"
  description = "pull ecr image for ecs task"
  policy      = data.aws_iam_policy_document.pull_ecr_image.json
}

# ECS タスク実行用の IAM ロール
data "aws_iam_policy_document" "ecs_task_execution" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "ecs_task_execution" {
  name               = "ecs_task_execution"
  description        = "ECS task execution role for next.js"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution.json
}

resource "aws_iam_role_policy_attachment" "pull_ecr_image_policy_to_ecs_task_execution" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = aws_iam_policy.pull_ecr_image.arn
}
