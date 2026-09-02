terraform {
  backend "s3" {
    bucket         = "olera-cloud-foundation-tfstate-830894827069"
    key            = "prod/terraform.tfstate"
    region         = "ap-southeast-1"
    encrypt        = true
    use_lockfile   = true
    dynamodb_table = "olera-cloud-foundation-locks"
  }
}
