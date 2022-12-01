terraform {
  required_version = "= 1.3.4"
}

provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "pipeline_magic_state" {
  bucket = "pipeline-magic-state"
}

resource "aws_s3_bucket_acl" "pipeline_magic_acl" {
  bucket = aws_s3_bucket.pipeline_magic_state.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "pipeline_magic_versioning" {
  bucket = aws_s3_bucket.pipeline_magic_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "pipeline_magic_enc" {
  bucket = aws_s3_bucket.pipeline_magic_state.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_dynamodb_table" "pipelie_magic_locks" {
  name         = "pipeline-magic-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
