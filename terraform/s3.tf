resource "aws_s3_bucket" "flyflow_artifact_bucket" {
  bucket = "flyflow-artifacts-${var.env}"

  tags = {
    Name        = "flyflow-artifacts"
    Application = "flyflow_devops"
    Environment = var.env
    Project     = "FlyFlowWorkflow"
  }
}



resource "aws_s3_bucket" "jenkins_backup" {
  bucket = "flyflow-jenkins-backup-staging"
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.jenkins_backup.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_iam_policy" "jenkins_s3_policy" {
  name = "jenkins-s3-backup-policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = ["s3:PutObject", "s3:GetObject", "s3:ListBucket"],
        Resource = [
          aws_s3_bucket.jenkins_backup.arn,
          "${aws_s3_bucket.jenkins_backup.arn}/*"
        ]
      }
    ]
  })
}


# ---------------------------------------------
# ---------------- Grafana setup --------------
# ---------------------------------------------

resource "aws_s3_bucket" "grafana_backup" {
  bucket = "flyflow-grafana-backups-staging"
}

resource "aws_s3_bucket_versioning" "grafana_versioning" {
  bucket = aws_s3_bucket.grafana_backup.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_iam_policy" "grafana_s3_policy" {
  name = "grafana-s3-backup-policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = ["s3:PutObject", "s3:GetObject", "s3:ListBucket"],
        Resource = [
          aws_s3_bucket.grafana_backup.arn,
          "${aws_s3_bucket.grafana_backup.arn}/*"
        ]
      }
    ]
  })
}
