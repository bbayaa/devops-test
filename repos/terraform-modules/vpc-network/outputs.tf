output "vpc" {
  value = aws_vpc.vpc
}

output "public_route_table" {
  value = length(var.public_cidrs) > 0 ? aws_route_table.public_route_table[0] : null
}

output "public_subnets" {
  value = aws_subnet.public_subnet.*
}

output "private_route_table" {
  value = aws_route_table.private_route_table
}

output "private_subnets" {
  value = aws_subnet.private_subnet.*
}
