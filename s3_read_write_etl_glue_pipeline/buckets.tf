resource "aws_s3_bucket" "dc-caco-source-data-bucket" {
  bucket        = var.source_bucket
  force_destroy = true
}

resource "aws_s3_object" "dc-caco-data-object" {
  bucket = aws_s3_bucket.dc-caco-source-data-bucket.bucket
  key    = "organizations.csv"
  source = "data/organizations.csv"
}

resource "aws_s3_bucket" "dc-caco-target-data-bucket" {
  bucket        = var.target_bucket
  force_destroy = true
}

resource "aws_s3_bucket" "dc-caco-code-bucket" {
  bucket        = var.code_bucket
  force_destroy = true
}

resource "aws_s3_object" "dc-caco-code-object" {
  bucket = aws_s3_bucket.dc-caco-code-bucket.bucket
  key    = "script.py"
  source = "scripts/script.py"
  etag   = filemd5("scripts/script.py")
}
