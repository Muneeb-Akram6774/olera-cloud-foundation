provider "aws" {
  region  = var.region
}

resource "aws_s3_bucket" "terraform_state" {
    bucket = var.olera-s3-bucket
    force_destroy = true

    tags = {
        Name = "Olera State Files Bucket"
        s3_environment = var.s3_environment
    }

}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
    bucket = aws_s3_bucket.terraform_state.id
    versioning_configuration {
      status = "Enabled"
    }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption" {
    bucket = aws_s3_bucket.terraform_state.id
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
}


resource "aws_dynamodb_table" "terraform_locks" {
    name = var.olera_dynamodb_table
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"

    attribute {
      name = "LockID"
      type = "S"
    }

    tags = {
        Name = "Olera Lock Table"
        s3_environment = var.s3_environment
    }
}