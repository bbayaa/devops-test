resource "aws_eks_cluster" "eks_cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids         = var.eks_subnet_ids
    security_group_ids = [aws_security_group.control_plane.id]
  }

  tags = merge(
    var.baseline_tags,
    {
      "Name"        = var.cluster_name
      "Description" = var.cluster_description
    }
  )
  
  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_AmazonEKSServicePolicy,
    aws_iam_role_policy_attachment.eks_cluster_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks_cluster_AmazonEKSVPCResourceController
  ]
}