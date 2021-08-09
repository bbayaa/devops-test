resource "aws_kms_alias" "vpc_flow_logs_cloudwatch_logs_kms_key_alias" {
  name          = "alias/${lower(replace(var.vpc_name, "/\\s/", "-"))}-vpc-flow-log-cloudwatch-log-group"
  target_key_id = aws_kms_key.vpc_flow_logs_cloudwatch_logs_kms_key.arn
}
