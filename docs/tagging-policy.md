# Tagging Policy

All resources managed by this project must use the following standard tags.

| Tag | Purpose | Example |
|-----|---------|---------|
| Project | Groups resources across the project for organization and cost tracking | olera-cloud-foundation |
| Environment | Identifies the deployment environment | dev, prod |
| Tier | Identifies the infrastructure or security tier | network, public, private, nat |
| ManagedBy | Identifies infrastructure ownership and management method | terraform |
| Name | Provides a human-readable resource identifier | olera-dev-vpc |

## Enforcement

Common organizational tags are defined once in each environment using a Terraform `locals` block:

```hcl
locals {
  common_tags = {
    Project     = "olera-cloud-foundation"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}