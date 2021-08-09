resource "aws_kms_key" "vpc_flow_logs_cloudwatch_logs_kms_key" {
  description             = "KMS key for CloudWatch log group containing VPC flow logs"
  is_enabled              = true
  deletion_window_in_days = 30
  enable_key_rotation     = true

  policy = data.aws_iam_policy_document.kms_cloudwatch_key_policy.json

  tags = merge(
    var.baseline_tags,
    {
      "Name"        = "CloudWatch VPC-Flow-Log Log Group KMS Key"
      "Description" = "KMS key for CloudWatch log group containing VPC Flow logs"
    }
  )
}