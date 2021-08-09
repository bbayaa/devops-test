resource "aws_subnet" "public_subnet" {
  count = length(var.public_cidrs)

  vpc_id               = aws_vpc.vpc.id
  cidr_block           = element(var.public_cidrs, count.index)
  availability_zone_id = element(var.az_ids, count.index % length(var.az_ids))

  tags = merge(
    var.baseline_tags,
    {
      "Name"        = "Public DMZ Subnet ${count.index + 1}"
      "Description" = "Public subnet for '${var.vpc_name}' VPC"
    },
    var.aux_public_subnet_tags
  )
}

resource "aws_subnet" "private_subnet" {
  count = length(var.private_cidrs)

  vpc_id               = aws_vpc.vpc.id
  cidr_block           = element(var.private_cidrs, count.index)
  availability_zone_id = element(var.az_ids, count.index % length(var.az_ids))

  tags = merge(
    var.baseline_tags,
    {
      "Name"        = "Private Subnet ${count.index + 1}"
      "Description" = "Private subnet for '${var.vpc_name}' VPC"
    },
    var.aux_private_subnet_tags
  )
}
