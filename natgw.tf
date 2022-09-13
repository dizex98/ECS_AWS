
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