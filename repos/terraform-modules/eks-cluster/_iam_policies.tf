# EKS Cluster
data "aws_iam_policy_document" "eks_trust_policy" {
  version = "2012-10-17"

  statement {
    sid    = "EKSServiceRoleTrustPolicy"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole"
    ]
  }
}

# Worker Nodes
data "aws_iam_policy_document" "worker_node_policy" {
  version = "2012-10-17"

  statement {
    sid    = "EC2ServiceRoleTrustPolicy"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole"
    ]
  }
}