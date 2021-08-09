variable "baseline_tags" {
  type        = map
  description = "Common tags to be included in all taggable resources"
}

variable "aux_vpc_tags" {
  type        = map
  description = "Other tags to include in the VPC-tagging structure"
}

variable "aux_public_subnet_tags" {
  type        = map
  description = "Other tags to include in the public-subnet tag structure"
}

variable "aux_private_subnet_tags" {
  type        = map
  description = "Other tags to include in the private-subnet tag structure"
}

variable "vpc_name" {
  type        = string
  description = "Friendly name/label for the VPC"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR range for VPC network"
}

variable "az_ids" {
  type        = list
  description = "The availability zones IDs you wish to distribute your subnets across (must match the region!)"
}

variable "public_cidrs" {
  type        = list
  description = "The CIDR ranges of your public subnets (leave blank for none)"
}

variable "private_cidrs" {
  type        = list
  description = "The CIDR ranges of your private subnets"
}

variable "include_nat_gateway" {
  type        = bool
  description = "Whether or not to include a NAT gateway"
  default     = false
}

variable "vpc_flow_log_cloudwatch_log_group_name" {
  type        = string
  description = "Name of CloudWatch log group for VPC flow logs"
}

variable "vpc_flow_logs_access_role_name" {
  type        = string
  description = "Name of IAM role for VPC flow logs to access CloudWatch"
  default     = "VPCFlowLogsCloudWatchAccessRole"
}