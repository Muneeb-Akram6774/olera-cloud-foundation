variable "region" {
    default = "us-east-1"
}

variable "olera-s3-bucket" {
    default = "olera-statefile-bucket"
}

variable "s3_environment" {
    default = "Dev"
}

variable "olera_dynamodb_table" {
    default = "olera-dynamodb_lock_table"
}