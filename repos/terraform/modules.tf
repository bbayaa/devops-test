module "eks_vpc" {
  source = "../terraform-modules/vpc-network"

  baseline_tags = var.baseline_tags

  aux_vpc_tags = {
    "Name"                                                   = "Heal-App VPC"
    "Description"                                            = "VPC for DevOps-test's Heal apps"
    "kubernetes.io/cluster/${var.heal_app_eks_cluster_name}" = "shared"
  }

  aux_public_subnet_tags = {
    "kubernetes.io/cluster/${var.heal_app_eks_cluster_name}" = "shared"
  }

  aux_private_subnet_tags = {
    "kubernetes.io/cluster/${var.heal_app_eks_cluster_name}" = "shared"
  }

  vpc_name                               = var.heal_app_vpc_name
  vpc_cidr                               = var.heal_app_vpc_cidr
  az_ids                                 = var.heal_app_az_ids
  public_cidrs                           = var.heal_app_public_cidrs
  private_cidrs                          = var.heal_app_private_cidrs
  include_nat_gateway                    = var.heal_app_vpc_include_nat_gateway
  vpc_flow_log_cloudwatch_log_group_name = var.heal_app_vpc_flow_log_cloudwatch_log_group_name
}

module "eks_cluster" {
  source = "../terraform-modules/eks-cluster"
  
  baseline_tags       = var.baseline_tags
  cluster_name        = var.heal_app_eks_cluster_name
  cluster_description = var.heal_app_eks_cluster_description
  eks_vpc             = module.eks_vpc
  eks_subnet_ids      = module.eks_vpc.private_subnets.*.id
}

# Ideally, the Vault instance should be provisioned on a seprate cluster altogether
# and be referenced by all apps in a centralized fashion
#module "vault_eks_cluster" {
#  source = "../terraform-modules/eks-cluster"
#  
#  baseline_tags       = var.baseline_tags
#  cluster_name        = var.vault_eks_cluster_name
#  cluster_description = var.vault_eks_cluster_description
#  eks_vpc             = module.eks_vpc
#  eks_subnet_ids      = module.eks_vpc.private_subnets.*.id
#}