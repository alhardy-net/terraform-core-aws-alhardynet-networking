output "vpc_id" {
  value       = module.aws-vpc.vpc_id
  description = "The VPC Identifier"
}

output "vpc_cidr_block" {
  value       = var.vpc_cidr
  description = "The CIDR block of the VPC"
}