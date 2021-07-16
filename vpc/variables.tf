variable "aws_account_id" {
  type        = string
  description = "The AWS Account Id for the deployment"
}

variable "aws_assume_role" {
  type        = string
  description = "The AWS Role to assume for the AWS account"
}

variable "vpc_cidr" {
  type        = string
  description = "The CIDR block of the VPC."
}

variable "public_subnet_count" {
  type        = number
  description = "The number of public subnets."
}

variable "enable_nat_gateway" {
  type        = bool
  default     = false
  description = "If true creates a nat gateway an adds route table entries for private application subnets"
}

variable "use_single_nat_gateway" {
  type        = bool
  default     = true
  description = "If true uses a single nat gateway in one AZ, otherwise deploys a nat gateway in each AZ"
}

variable "private_application_subnet_count" {
  type        = number
  description = "The number of private application subnets."
}

variable "private_persistence_subnet_count" {
  type        = number
  description = "The number of private persistence subnets."
}

variable "private_persistence_subnet_enable_nat_gateway" {
  type        = bool
  default     = false
  description = "Adds route tables entries to private persistence subnet for the nat gateway"
}

# Terraform Cloud
variable "TFC_WORKSPACE_SLUG" {
  type        = string
  default     = "local"
  description = "This is the full slug of the configuration used in this run. This consists of the organization name and workspace name, joined with a slash"
}