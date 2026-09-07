# networking module

Provisions a multi-AZ VPC with public/private subnet separation, one NAT Gateway per AZ, and appropriate routing for a production-style landing zone.

## Design decisions

**NAT Gateway: one per AZ, not shared.**

The module uses one NAT Gateway in each Availability Zone rather than a single shared NAT Gateway. This avoids making a single NAT Gateway a cross-AZ single point of failure. If one AZ or its NAT Gateway experiences an outage, private subnets in the other AZ retain outbound internet connectivity through their local NAT Gateway.

The trade-off is cost. Running one NAT Gateway per AZ costs more than using a single shared NAT Gateway, particularly because NAT Gateways incur hourly and data-processing charges. For a two-AZ deployment, this means approximately twice the NAT Gateway hourly cost compared with a single shared gateway, before considering data-processing charges.

For production workloads, the additional cost is generally justified by improved availability, AZ isolation, and reduced dependency on cross-AZ traffic. A cost-sensitive development or test environment may reasonably choose a single shared NAT Gateway if the lower cost is more important than AZ-level outbound resiliency.

## Inputs

| Name | Type | Description |
|------|------|-------------|
| `environment` | `string` | Environment name (dev/prod) - used for tagging and naming. Must contain only lowercase letters, numbers, and hyphens. |
| `vpc_cidr` | `string` | CIDR block for the VPC. Must be a valid IPv4 CIDR block. |
| `azs` | `list(string)` | Availability zones to deploy across. Must contain at least two unique Availability Zones. |
| `public_subnet_cidrs` | `list(string)` | CIDR blocks for public subnets, one per AZ. Each value must be a valid IPv4 CIDR block and the list must contain exactly one CIDR per AZ. |
| `private_subnet_cidrs` | `list(string)` | CIDR blocks for private subnets, one per AZ. Each value must be a valid IPv4 CIDR block and the list must contain exactly one CIDR per AZ. |

## Outputs

| Name | Description |
|------|-------------|
| `vpc_id` | ID of the created VPC. |
| `public_subnet_ids` | Map of Availability Zone to public subnet ID. |
| `private_subnet_ids` | Map of Availability Zone to private subnet ID. |
| `nat_gateway_ids` | Map of Availability Zone to NAT Gateway ID. |

## Deployed outputs

The following outputs are from the deployed `dev` environment:

```text
nat_gateway_ids = {
  "ap-southeast-1a" = "nat-033604528f337469f"
  "ap-southeast-1b" = "nat-0cbd1c8bc13ae76de"
}

private_subnet_ids = {
  "ap-southeast-1a" = "subnet-0b4f573b8f407b16f"
  "ap-southeast-1b" = "subnet-0ebef6128043fc6a0"
}

public_subnet_ids = {
  "ap-southeast-1a" = "subnet-0a2e184dc78ce96d8"
  "ap-southeast-1b" = "subnet-0d84944f80ae1211f"
}

vpc_id = "vpc-0cc2620edf26418ca"

## Deployment summary

| Resource | `ap-southeast-1a` | `ap-southeast-1b` |
|----------|-------------------|-------------------|
| Public subnet | `subnet-0a2e184dc78ce96d8` | `subnet-0d84944f80ae1211f` |
| Private subnet | `subnet-0b4f573b8f407b16f` | `subnet-0ebef6128043fc6a0` |
| NAT Gateway | `nat-033604528f337469f` | `nat-0cbd1c8bc13ae76de` |

**VPC:** `vpc-0cc2620edf26418ca`

## Architecture

The module deploys the networking layer across two Availability Zones:

- A single VPC containing dedicated public and private subnets.
- One public subnet per Availability Zone.
- One private subnet per Availability Zone.
- One NAT Gateway per Availability Zone.
- Public routing through an Internet Gateway.
- Private subnet outbound traffic routed through the NAT Gateway in the same Availability Zone.
- AZ-local NAT routing to improve resilience and avoid unnecessary cross-AZ dependencies.

This design provides a foundation suitable for production-style workloads while keeping the network topology straightforward and predictable.
