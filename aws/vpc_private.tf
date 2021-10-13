resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.example.id
  for_each                = local.private_subnet
  availability_zone       = each.key
  cidr_block              = each.value
  map_public_ip_on_launch = true
}

resource "aws_eip" "nat_gateway" {
  count      = 2
  vpc        = true
  depends_on = [aws_internet_gateway.example]
}

resource "aws_nat_gateway" "private_subnet" {
  count         = 2
  allocation_id = aws_eip.nat_gateway[count.index].id
  subnet_id     = aws_subnet.private[local.zones[count.index]].id
  depends_on    = [aws_internet_gateway.example]
}

resource "aws_route_table" "private" {
  count  = 2
  vpc_id = aws_vpc.example.id
}

resource "aws_route" "private" {
  count                  = 2
  route_table_id         = aws_route_table.private[count.index].id
  nat_gateway_id         = aws_nat_gateway.private_subnet[count.index].id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "private" {
  count          = 2
  subnet_id      = aws_subnet.private[local.zones[count.index]].id
  route_table_id = aws_route_table.private[count.index].id
}
