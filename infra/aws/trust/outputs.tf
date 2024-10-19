output "role_arn" {
  description = "Terraform Cloud の環境変数へ登録するのに必要"
  value       = aws_iam_role.terraform_cloud.arn
}
