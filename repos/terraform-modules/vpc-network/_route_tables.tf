# "local" route is created implicitly
resource "aws_route_table" "public_route_table" {
  count = length(var.public_cidrs) > 0 ? 1 : 0

  vpc_id = aws_vpc.vpc.id

  tags = merge(
    var.baseline_tags,
    {
      "Name"        = "VPC Public RT"
      "Description" = "Public route table for VPC"
    }
  )
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    var.baseline_tags,
    {
      "Name"        = "VPC Private RT"
      "Description" = "Private route table for VPC"
    }
  )
}

# Create route-table associations
resource "aws_route_table_association" "public_subnet_route_table_association" {
  count = length(var.public_cidrs)

  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public_route_table[0].id
}

resource "aws_route_table_association" "private_subnet_route_table_association" {
  count = length(var.private_cidrs)

  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.private_route_table.id
}
