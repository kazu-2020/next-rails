terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.56.1"
    }
  }
}

provider "aws" {}

data "aws_partition" "current" {}

# TLS 証明書を取得するためのデータソースを定義
data "tls_certificate" "terraform_cloud" {
  url = format("https://%s", var.terraform_cloud_host)
}

# Terraform Cloud 用の OpenID Connect プロバイダを定義
resource "aws_iam_openid_connect_provider" "terraform_cloud" {
  url = data.tls_certificate.terraform_cloud.url
  # OpenID Connect audience
  client_id_list  = ["aws.workload.identity"]
  thumbprint_list = [data.tls_certificate.terraform_cloud.certificates[0].sha1_fingerprint]
}

# 信頼ポリシー
data "aws_iam_policy_document" "terraform_assume_role_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.terraform_cloud.arn]
    }

    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringEquals"
      variable = "${var.terraform_cloud_host}:aud"

      values = [
        # OpenID Connect audience
        one(aws_iam_openid_connect_provider.terraform_cloud.client_id_list)
      ]
    }

    condition {
      test     = "StringLike"
      variable = "${var.terraform_cloud_host}:sub"

      values = [
        format("organization:%s:project:%s:workspace:%s:run_phase:%s",
          var.terraform_cloud_organization,
          var.terraform_cloud_project,
          var.terraform_cloud_workspace,
          var.terraform_cloud_run_phase
        ),
      ]
    }
  }
}

resource "aws_iam_role" "terraform_cloud" {
  name               = "terraform-cloud"
  assume_role_policy = data.aws_iam_policy_document.terraform_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "terraform_policy_attachment" {
  role       = aws_iam_role.terraform_cloud.name
  policy_arn = format("arn:%s:iam::aws:policy/AdministratorAccess", data.aws_partition.current.partition)
}
