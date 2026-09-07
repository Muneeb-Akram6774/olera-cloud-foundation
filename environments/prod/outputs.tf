output "vpc_id" {
  description = "ID of the environment VPC."
  value       = module.networking.vpc_id
}

output "public_subnet_ids" {
  description = "Map of AZ to public subnet ID."
  value       = module.networking.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Map of AZ to private subnet ID."
  value       = module.networking.private_subnet_ids
}

output "nat_gateway_ids" {
  description = "Map of AZ to NAT Gateway ID."
  value       = module.networking.nat_gateway_ids
}
