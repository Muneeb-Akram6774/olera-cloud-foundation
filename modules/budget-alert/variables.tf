variable "environment" {
  type        = string
  description = "Environment name (dev/prod)."
}

variable "budget_amount" {
  type        = number
  description = "Monthly AWS cost budget in USD."

  validation {
    condition     = var.budget_amount > 0
    error_message = "budget_amount must be greater than 0."
  }
}

variable "notification_email" {
  type        = string
  description = "Email address that receives AWS budget notifications."

  validation {
    condition     = can(regex("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$", var.notification_email))
    error_message = "notification_email must be a valid email address."
  }
}