#### subnets with internal ip's only and internet acces from nat gateway

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.name} Private route table"
  }
}

resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = element(aws_subnet.public.*.id, local.subnet_nat_index)
  depends_on    = [aws_internet_gateway.main]
}

resource "aws_subnet" "private" {
  count  = local.subnet_count
  vpc_id = aws_vpc.main.id

  ## avoid ip collision
  cidr_block = cidrsubnet(var.cidr_block[var.region], var.private_subnet_size, count.index + local.netnum_private)

  availability_zone       = element(var.availability_zones[var.region], count.index)
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.name} Private ${element(var.availability_zones[var.region], count.index)}"
  }
}

resource "aws_route_table_association" "private" {
  count          = local.subnet_count
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private.id
}


resource "aws_route" "nat" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}
