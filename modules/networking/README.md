# Networking Module

Reusable multi-AZ VPC networking for the Olera Cloud Foundation environments.

The module creates a VPC, public and private subnets, an Internet Gateway, one NAT Gateway per Availability Zone, a shared public route table, and one private route table per Availability Zone.

## Design

```text
                 Internet
                    |
               Internet GW
                    |
          +---------+---------+
          |   Public RT       |
          +---------+---------+
             /             \
         Public AZ-a     Public AZ-b
             |               |
          NAT GW-a         NAT GW-b
             |               |
       Private RT-a      Private RT-b
             |               |
        Private AZ-a    Private AZ-b
```

Each private subnet routes `0.0.0.0/0` to the NAT Gateway in the same Availability Zone. This avoids making another AZ's NAT Gateway a dependency for private-subnet egress.

## NAT Gateway decision

> Chose one NAT Gateway per AZ over a single shared NAT Gateway to avoid a cross-AZ single point of failure, if one AZ's NAT Gateway or the AZ itself has an outage, private subnets in other AZs retain outbound connectivity. Trade-off: roughly 2x the NAT Gateway cost (~$32-65/month extra depending on region) compared to a single shared NAT Gateway. For a real production workload this resiliency is usually worth it; for a pure cost-minimization case, a single NAT Gateway would be the alternative.

The exact monthly cost varies with AWS region and data processing, so the figure above is a planning estimate rather than a guaranteed bill.

## Inputs

| Name | Type | Description |
|---|---|---|
| `environment` | `string` | Environment name used for tagging and naming. |
| `vpc_cidr` | `string` | VPC IPv4 CIDR block. |
| `azs` | `list(string)` | Availability Zones to deploy across. Must contain at least two unique AZs. |
| `public_subnet_cidrs` | `list(string)` | One public subnet CIDR per AZ. |
| `private_subnet_cidrs` | `list(string)` | One private subnet CIDR per AZ. |

## Outputs

| Name | Type | Description |
|---|---|---|
| `vpc_id` | `string` | VPC ID. |
| `public_subnet_ids` | `map(string)` | AZ-to-public-subnet-ID map. |
| `private_subnet_ids` | `map(string)` | AZ-to-private-subnet-ID map. |
| `nat_gateway_ids` | `map(string)` | AZ-to-NAT-Gateway-ID map. |

## Operational notes

NAT Gateways and Elastic IP addresses are billable AWS resources. This module intentionally chooses resilience over minimum cost for the portfolio's production-oriented design.
