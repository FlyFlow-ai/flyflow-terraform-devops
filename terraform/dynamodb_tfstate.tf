resource "aws_dynamodb_table" "tfstate_locking" {
  name           = "tfstate-locking"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"  # "S" stands for String
  }

  tags = {
    Name        = "tfstate-locking"
    Application = "main_terraform"
    Environment = "staging"
    Project     = "FlyFlowWorkflow"
  }
}
