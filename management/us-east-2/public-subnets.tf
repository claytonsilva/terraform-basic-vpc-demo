#### subnets with elastic ip's and internet accessible

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.name} Public route table"
  }
}

resource "aws_subnet" "public" {
  count      = local.subnet_count
  vpc_id     = aws_vpc.main.id
  cidr_block = cidrsubnet(var.cidr_block[var.region], var.public_subnet_size, count.index + 0)

  availability_zone       = element(var.availability_zones[var.region], count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name} Public ${element(var.availability_zones[var.region], count.index)}"
  }
}

resource "aws_route_table_association" "public" {
  count          = local.subnet_count
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}


resource "aws_route" "public_igw" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}
