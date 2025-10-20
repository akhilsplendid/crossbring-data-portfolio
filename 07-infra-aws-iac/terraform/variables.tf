variable "region" {
  type        = string
  description = "AWS region"
  default     = "eu-north-1"
}

variable "bucket_name" {
  type        = string
  description = "S3 bucket for Iceberg data"
}

variable "snowflake_aws_principal_arn" {
  type        = string
  description = "Snowflake AWS principal ARN for role assumption"
}

