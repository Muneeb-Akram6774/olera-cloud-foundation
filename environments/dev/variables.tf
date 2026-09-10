variable "aws_region" {
  description = "AWS region for the environment."
  type        = string
  default     = "ap-southeast-1"
}

variable "environment" {
  description = "Environment name."
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block."
  type        = string
}

variable "azs" {
  description = "Availability Zones for the environment."
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs, one per AZ."
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDRs, one per AZ."
  type        = list(string)
}


variable "budget_amount" {
  type        = number
  description = "Monthly AWS budget in USD."
  default     = 25
}

variable "notification_email" {
  type        = string
  description = "Email address for AWS budget alerts."
}
