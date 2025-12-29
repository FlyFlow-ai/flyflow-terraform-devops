terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "6.2.2"
    }
  }
}
provider "github" {
  token = aws_ssm_parameter.github_token.value
}