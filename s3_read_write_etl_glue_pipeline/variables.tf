variable "aws_region" {
  description = "AWS region to deploy resources"
  default     = "us-east-1"
}

variable "sandbox_prefix" {
  description = "Sandbox prefix for this trainning project"
  default     = "dc-caco"
}

variable "source_bucket" {
  description = "S3 bucket for source data"
  default     = "dc-caco-source-data-bucket"
}

variable "target_bucket" {
  description = "S3 bucket for target data"
  default     = "dc-caco-target-data-bucket"
}

variable "code_bucket" {
  description = "S3 bucket for Glue job scripts"
  default     = "dc-caco-code-bucket"
}
