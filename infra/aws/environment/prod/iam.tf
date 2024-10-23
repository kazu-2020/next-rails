####################
# ECS で利用する IAM ロールとポリシーを作成する
####################

data "aws_iam_policy_document" "ecs_task_execution" {
  # ECR からイメージを取得するためのポリシー
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

  statement {
    effect = "Allow"

    sid = "CloudWatchLogs"

    actions = [
      "logs:CreateLogStream",
      " logs:PutLogEvents",
    ]
  }
}

resource "aws_iam_policy" "ecs_task_execution" {
  name        = "ECSTaskExecutionPolicy"
  description = "ecs task execution policy for app"
  policy      = data.aws_iam_policy_document.ecs_task_execution.json
}

# ECS タスク実行用の IAM ロール
data "aws_iam_policy_document" "ecs_task_execution_assume_role" {
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
  name               = "ECSTaskExecutionRole"
  description        = "ECS task execution role for next.js"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_assume_role.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy_to_ecs_task_execution" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = aws_iam_policy.ecs_task_execution.arn
}
