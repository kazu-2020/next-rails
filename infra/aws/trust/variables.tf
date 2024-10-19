variable "terraform_cloud_host" {
  type        = string
  description = "Terraform Cloud のホスト名"
  default     = "app.terraform.io"
}

variable "terraform_cloud_organization" {
  type        = string
  description = "Terraform Cloud の組織名"
}

variable "terraform_cloud_project" {
  type        = string
  description = "Terraform Cloud のプロジェクト名"
  default     = "*"
}

variable "terraform_cloud_workspace" {
  type        = string
  description = "Terraform Cloud のワークスペース名"
  default     = "*"
}

variable "terraform_cloud_run_phase" {
  type        = string
  description = "Terraform Cloud の実行フェーズ"
  default     = "*"
}
