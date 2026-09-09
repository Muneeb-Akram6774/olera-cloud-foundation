locals {
  common_tags = {
    Project     = "olera-cloud-foundation"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

module "networking" {
  source = "../../modules/networking"

  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  azs                  = var.azs
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs

  common_tags = local.common_tags
}

module "iam_boundary" {
  source = "../../modules/iam-boundary"

  environment      = var.environment
  aws_region       = var.aws_region
  state_bucket_arn = "arn:aws:s3:::olera-cloud-foundation-tfstate-830894827069"
  lock_table_arn   = "arn:aws:dynamodb:${var.aws_region}:830894827069:table/olera-cloud-foundation-locks"
}