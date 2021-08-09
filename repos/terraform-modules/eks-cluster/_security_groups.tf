# Security-group rules
resource "aws_security_group_rule" "allow_https_traffic" {
  type              = "ingress"
  description       = "Allow access to HTTPS"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.control_plane.id
}

resource "aws_security_group_rule" "allow_control_plane_egress_to_worker_nodes" {
  type              = "egress"
  description       = "Allow the cluster control plane to communicate with worker-node kubelet agents and underlying pods"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.control_plane.id
}

resource "aws_security_group_rule" "allow_worker_node_egress" {
  type              = "egress"
  description       = "Allow outbound communication from worker nodes"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.worker_node.id
}

resource "aws_security_group_rule" "allow_worker_node_ingress_self" {
  type                     = "ingress"
  description              = "Allow all worker nodes to communicate with each other"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "-1"
  source_security_group_id = aws_security_group.worker_node.id
  security_group_id        = aws_security_group.worker_node.id
}

resource "aws_security_group_rule" "allow_worker_node_ingress_control_plane" {
  type                     = "ingress"
  description              = "Allow worker kubelet agents and pods to receive communication from the cluster control plane"
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.control_plane.id
  security_group_id        = aws_security_group.worker_node.id
}

# Security groups
resource "aws_security_group" "control_plane" {
  name        = "${var.cluster_name}-control-plane"
  description = "[Terraform-managed] Security group for all EKS control plane in the cluster"
  vpc_id      = var.eks_vpc.vpc.id

  # "owned" value below signifies that only this cluster can use this security group
  tags = merge(
    var.baseline_tags, 
    {
      "Name"                                      = "${var.cluster_name}-app-eks-control-plane"
      "Description"                               = "Security group for the ${var.cluster_name} EKS control plane managed by Terraform"
      "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    }
  )
}

resource "aws_security_group" "worker_node" {
  name        = "${var.cluster_name}-app-eks-node"
  description = "[Terraform-managed] Security group for all EKS worker nodes in the cluster"
  vpc_id      = var.eks_vpc.vpc.id

  # "owned" value below signifies that only this cluster can use this security group
  tags = merge(
    var.baseline_tags, 
    {
      "Name"                                      = "${var.cluster_name}-app-eks-node"
      "Description"                               = "Security group for EKS worker nodes managed by Terraform"
      "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    }
  )
}
