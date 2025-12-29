resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}
# Store the generated public key in AWS SSM Parameter Store
resource "aws_ssm_parameter" "public_key" {
  name  = var.key_ssm_name
  type  = "String"
  value = tls_private_key.ssh_key.public_key_openssh
  overwrite = true
}
resource "aws_ssm_parameter" "private_key" {
  name  = "/key_pairs/flyflow/private_key"
  type  = "SecureString"
  value = tls_private_key.ssh_key.private_key_pem
  overwrite = true
}

# Define an AWS Key Pair using the generated public key
resource "aws_key_pair" "ec2_key_pair" {
  key_name   = var.ssh_key_name
  public_key = tls_private_key.ssh_key.public_key_openssh
}

## Customers Ec2 Build instances ssm

resource "tls_private_key" "ssh_key_customer" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_ssm_parameter" "public_key_customer" {
  name  = "/shared/flyflow_customers/public_key"
  type  = "String"
  value = tls_private_key.ssh_key_customer.public_key_openssh
  overwrite = true
}

resource "aws_key_pair" "ec2_key_pair_customer" {
  key_name   = "customers_aws_key"
  public_key = tls_private_key.ssh_key_customer.public_key_openssh
}

resource "aws_ssm_parameter" "customer_sg" {
  name  = "/shared/application/ec2/server-sg"
  type  = "String"
  value = aws_security_group.allow_ssh_customers.id
}

resource "aws_ssm_parameter" "customer_account_id" {
  name  = "/shared/application/ec2/aws-account-id"
  type  = "String"
  value = "580186901909"
}

resource "aws_ssm_parameter" "aws_access_key_id" {
  name  = "/devops/aws_access_key_id"
  type  = "SecureString"
  value = "change_me"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "aws_secret_key" {
  name  = "/devops/aws_secret_key"
  type  = "SecureString"
  value = "change_me"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "github_token" {
  name  = "/devops/github_token"
  type  = "SecureString"
  value = "change_me"

  lifecycle {
    ignore_changes = [value]
  }
}