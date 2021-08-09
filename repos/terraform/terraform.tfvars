# Provider variables are passed into the Dockerfile as environment variables

# Script variables
baseline_tags = {
  "Project"        = "Heal DevOps Test"
  "Auto-Generated" = "true"
}

###########################################
### VPC-module parameters
###########################################
heal_app_vpc_name                               = "heal-eks-vpc"
heal_app_vpc_cidr                               = "10.8.0.0/16"
heal_app_az_ids                                 = ["use1-az1", "use1-az2"]
heal_app_public_cidrs                           = ["10.8.1.0/24", "10.8.2.0/24"]
heal_app_private_cidrs                          = ["10.8.3.0/24", "10.8.4.0/24"]
heal_app_vpc_include_nat_gateway                = true
heal_app_vpc_flow_log_cloudwatch_log_group_name = "heal-app-vpc-flow-logs/traffic-logs"

###########################################
### EKS-module parameters
###########################################
heal_app_eks_cluster_name        = "heal-eks"
heal_app_eks_cluster_description = "EKS cluster hosting the Heal DevOps test app"

# Ideally, the Vault instance should be provisioned on a seprate cluster altogether
# and be referenced by all apps in a centralized fashion
############################################
#### Vault-module parameters
############################################
#vault_eks_cluster_name        = "vault-eks"
#vault_eks_cluster_description = "EKS cluster hosting the Heal Hashicorp Vault instance"