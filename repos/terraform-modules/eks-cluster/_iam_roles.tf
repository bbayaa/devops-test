# EKS Cluster
resource "aws_iam_role" "eks_cluster_role" {
  name               = "EKSServiceAccessRole_${replace(var.cluster_name, " ", "")}"
  assume_role_policy = data.aws_iam_policy_document.eks_trust_policy.json

  tags = merge(
    var.baseline_tags, 
    {
      "Name"        = "EKSServiceAccessRole_${replace(var.cluster_name, " ", "")}"
      "Description" = "IAM role allowing EKS to access other AWS services"
    }
  )
}

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_cluster_role.name
}

# Worker Nodes
resource "aws_iam_role" "worker_node" {
  name               = "EKSWorkerNodeRole_${replace(var.cluster_name, " ", "")}"
  assume_role_policy = data.aws_iam_policy_document.worker_node_policy.json

  tags = merge(
    "${var.baseline_tags}", 
    {
      "Name"        = "EKSWorkerNodeRole_${replace(var.cluster_name, " ", "")}"
      "Description" = "IAM role allowing Kubernetes worker nodes cluster access"
    }
  )
}

resource "aws_iam_role_policy_attachment" "worker_node_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.worker_node.name
}

resource "aws_iam_role_policy_attachment" "worker_node_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.worker_node.name
}

resource "aws_iam_role_policy_attachment" "worker_node_AmazonEKS_ECR_Readonly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.worker_node.name
}