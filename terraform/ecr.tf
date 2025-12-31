resource "aws_ecr_repository" "auth_service" {
  name                 = "auth-service-staging"
  image_tag_mutability = "MUTABLE"
}