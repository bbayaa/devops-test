variable "baseline_tags" {
  type        = map
  description = "Common tags to be included in all taggable resources"
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
}

variable "cluster_description" {
  description = "The description of the EKS cluster"
}

variable "eks_vpc" {
  description = "The VPC of the EKS cluster"
  
  type = object({
  
    vpc = object({
      id       = string
      owner_id = string
    })
    
    public_subnets = set(object({
      id = string
    }))
    
    private_subnets = set(object({
      id = string
    }))

    public_route_table = object({
      id = string
    })

    private_route_table = object({
      id = string
    })
  })
}

variable "eks_subnet_ids" {
  type = list
  description = "List of subnet IDs, corresponding to the list of subnets in which to deploy EKS worker nodes"
}