
resource "aws_eip" "eip_natgw_1" {
  vpc = true

  tags = {
    Name = "Elastic IP - For NAT GW 1"
  }
}

resource "aws_eip" "eip_natgw_2" {
  vpc = true

  tags = {
    Name = "Elastic IP - For NAT GW 2"
  }
}

resource "aws_nat_gateway" "natgw_1" {
  allocation_id = aws_eip.eip_natgw_1.id
  subnet_id     = aws_subnet.public_subnet_1.id

  tags = {
    Name = "NAT GW 1"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.main]
}

resource "aws_nat_gateway" "natgw_2" {
  allocation_id = aws_eip.eip_natgw_2.id
  subnet_id     = aws_subnet.public_subnet_2.id

  tags = {
    Name = "NAT GW 2"
  }

  depends_on = [aws_internet_gateway.main]
}

resource "aws_route_table" "private_rt_1" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw_1.id
  }

  tags = {
    Name = "Private Route Table 1"
  } 
}

resource "aws_route_table" "private_rt_2" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw_2.id
  }

  tags = {
    Name = "Private Route Table 2"
  } 
}

resource "aws_route_table_association" "private_subnet1_assosciation" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_rt_1.id
}

resource "aws_route_table_association" "private_subnet2_assosciation" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_rt_2.id
}