resource "aws_vpc" "example" {
  cidr_block           = local.cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = format("%s-vpc", local.user)
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.example.id
  for_each                = local.public_subnet
  availability_zone       = each.key
  cidr_block              = each.value
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example.id
  tags   = local.tags
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.example.id
  tags   = local.tags
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.example.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "public" {
  for_each       = local.public_subnet
  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public.id
}
