variable "github_repositories" {
  description = "GitHub repositories that should receive shared secrets"
  type        = set(string)

  default = [
    "flyflow-engine-core",
    "flyflow-engine-api",
    "flyflow-engine-worker",
  ]
}

locals {
  shared_github_secrets = {
    AWS_ACCESS_KEY_ID     = aws_ssm_parameter.aws_access_key_id.value
    AWS_SECRET_ACCESS_KEY = aws_ssm_parameter.aws_secret_key.value
    AWS_REGION            = "us-east-1"
    ARTIFACT_BUCKET       = aws_s3_bucket.flyflow_artifact_bucket.bucket
    GH_FLYFLOW_TOKEN      = aws_ssm_parameter.github_token.value
  }

  repo_secret_pairs = setproduct(
    tolist(var.github_repositories),
    keys(local.shared_github_secrets)
  )
}

resource "github_actions_secret" "shared_secrets" {
  for_each = {
    for pair in local.repo_secret_pairs :
    "${pair[0]}.${pair[1]}" => {
      repository = pair[0]
      name       = pair[1]
      value      = local.shared_github_secrets[pair[1]]
    }
  }

  repository      = each.value.repository
  secret_name     = each.value.name
  plaintext_value = each.value.value
}
