terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "iceberg" {
  bucket = var.bucket_name
}

resource "aws_iam_role" "snowflake_role" {
  name               = "snowflake_external_access_role"
  assume_role_policy = data.aws_iam_policy_document.snowflake_assume.json
}

data "aws_iam_policy_document" "snowflake_assume" {
  statement {
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [var.snowflake_aws_principal_arn]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role_policy" "snowflake_s3_policy" {
  name = "snowflake_s3_access"
  role = aws_iam_role.snowflake_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["s3:ListBucket"],
        Resource = [aws_s3_bucket.iceberg.arn]
      },
      {
        Effect = "Allow",
        Action = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"],
        Resource = ["${aws_s3_bucket.iceberg.arn}/*"]
      }
    ]
  })
}

output "bucket_name" {
  value = aws_s3_bucket.iceberg.bucket
}

output "iam_role_arn" {
  value = aws_iam_role.snowflake_role.arn
}

