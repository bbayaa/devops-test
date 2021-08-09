resource "aws_internet_gateway" "igw" {
  count  = length(var.public_cidrs) > 0 ? 1 : 0

  vpc_id = aws_vpc.vpc.id

  tags = merge(
    var.baseline_tags,
    {
      "Name"        = "VPC IGW"
      "Description" = "Internet gateway for VPC public subnets"
    }
  )
}

# Create an EIP to associate with the NAT gateway
resource "aws_eip" "ngw_eip" {
  count = var.include_nat_gateway == true && length(var.public_cidrs) > 0 ? 1 : 0

  tags = merge(
    var.baseline_tags,
    {
      "Name"        = "NAT-Gateway EIP"
      "Description" = "Elastic IP address for NAT gateway in VPC"
    }
  )

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "ngw" {
  count         = var.include_nat_gateway == true && length(var.public_cidrs) > 0 ? 1 : 0
  allocation_id = aws_eip.ngw_eip[count.index].id
  subnet_id     = element(aws_subnet.public_subnet.*.id, 0)
  
  depends_on = [aws_internet_gateway.igw]
}
