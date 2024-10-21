resource "aws_ecr_repository" "app_next" {
  name = "app/next"

  image_tag_mutability = "IMMUTABLE"
}
