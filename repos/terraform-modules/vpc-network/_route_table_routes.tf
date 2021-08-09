resource "aws_route" "public_subnets_to_igw" {
  count = length(var.public_cidrs) > 0 ? 1 : 0

  route_table_id         = aws_route_table.public_route_table[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw[count.index].id
}

resource "aws_route" "private_subnets_to_ngw" {
  count = var.include_nat_gateway == true && length(var.public_cidrs) > 0 ? 1 : 0

  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.ngw[count.index].id
  
  timeouts {
    create = "5m"
  }
  
  depends_on             = [aws_nat_gateway.ngw]
}
