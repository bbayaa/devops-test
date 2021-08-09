variable "aws_profile" {
  description = "The AWS profile with permissions to provision this infrastructure"
}

variable "aws_region" {
  default     = "us-east-1"
  description = "The AWS region in which to provision the AWS infrastructure"
}

variable "baseline_tags" {
  type        = map
  description = "Common tags to be included in all taggable resources"
}

###########################################
### VPC-module parameters
###########################################

variable "heal_app_vpc_name" {
  description = "Friendly name/label for the VPC"
}

variable "heal_app_vpc_cidr" {
  description = "CIDR range for VPC network"
}

variable "heal_app_az_ids" {
  type        = list
  description = "The IDs of the availability zones you wish to distribute your subnets across (must match the region!)"
}

variable "heal_app_public_cidrs" {
  type        = list
  description = "The CIDR ranges of your public subnets (leave blank for none)"
}

variable "heal_app_private_cidrs" {
  type        = list
  description = "The CIDR ranges of your private subnets"
}

variable "heal_app_vpc_include_nat_gateway" {
  default     = false
  description = "Whether or not to include a NAT gateway"
}

variable "heal_app_vpc_flow_log_cloudwatch_log_group_name" {
  description = "Name of CloudWatch log group for VPC flow logs"
}

###########################################
### EKS-module parameters
###########################################
variable "heal_app_eks_cluster_name" {
  description = "Name of the EKS cluster to host the Heal test app"
}

variable "heal_app_eks_cluster_description" {
  description = "Description of the EKS cluster hosting the Heal test app"
}

# Ideally, the Vault instance should be provisioned on a seprate cluster altogether
# and be referenced by all apps in a centralized fashion
############################################
#### Vault-module parameters
############################################
#variable "vault_eks_cluster_name" {
#  description = "Name of the EKS cluster to host Hashicorp Vault"
#}
#
#variable "vault_eks_cluster_description" {
#  description = "Description of the EKS cluster hosting Hashicorp Vault"
#}