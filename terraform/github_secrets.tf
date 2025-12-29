variable "github_repositories" {
  description = "GitHub repositories that should receive shared secrets"
  type        = set(string)
  default = [
    "flyflow-engine-core",
    "flyflow-engine-api",
    "flyflow-engine-worker"
  ]
}
locals {
  shared_github_secrets = {
    AWS_ACCESS_KEY_ID = aws_ssm_parameter.aws_access_key_id.value
    AWS_SECRET_ACCESS_KEY = aws_ssm_parameter.aws_secret_key.value
    AWS_REGION = "us-east-1"
    ARTIFACT_BUCKET = aws_s3_bucket.flyflow_artifact_bucket.bucket
    GH_FLYFLOW_TOKEN = aws_ssm_parameter.github_token.value
  }
}

resource "github_actions_secret" "shared_secrets" {
  for_each = {
      for repo in var.github_repositories :
        for secret_name, secret_value in local.shared_github_secrets :
             "${repo}.${secret_name}" => {
               repository = repo
               name       = secret_name
               value      = secret_value
            }
  }

repository      = each.value.repository
secret_name     = each.value.name
plaintext_value = each.value.value
}