resource "aws_flow_log" "flow_logs" {
  iam_role_arn         = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.vpc_flow_logs_access_role_name}"
  log_destination      = "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:${var.vpc_flow_log_cloudwatch_log_group_name}:*"
  log_destination_type = "cloud-watch-logs"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.vpc.id
}