variable "aws_region_this" {
  type        = string
  description = "The region of the hub vpc"
}

variable "aws_account_id_this" {
  type        = string
  description = "The AWS Account Id for the deployment"
}

variable "aws_account_id_stage" {
  type        = string
  description = "The AWS Account Id of the stage account to peer with"
}

variable "aws_account_id_prod" {
  type        = string
  description = "The AWS Account Id of the prod account to peer with"
}

variable "aws_assume_role" {
  type        = string
  description = "The AWS Role to assume for the AWS account"
}

variable "hub_vpc_id" {
  type        = string
  description = "The VPC ID of the stage account"
}

variable "stage_vpc_id" {
  type        = string
  description = "The VPC ID of the stage account"
}

variable "prod_vpc_id" {
  type        = string
  description = "The VPC ID of the prod account"
}

# Terraform Cloud
variable "TFC_WORKSPACE_SLUG" {
  type        = string
  default     = "local"
  description = "This is the full slug of the configuration used in this run. This consists of the organization name and workspace name, joined with a slash"
}