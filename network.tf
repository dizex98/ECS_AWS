resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "main"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = var.az1

  tags = {
    Name = "Public subnet 1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = var.az2

  tags = {
    Name = "Public subnet 2"
  }
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = var.az1

  tags = {
    Name = "Private subnet 1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = var.az2

  tags = {
    Name = "Private subnet 2"
  }
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  depends_on = [
    aws_internet_gateway.main
  ]

  tags = {
    Name = "Route Table"
  } 
}


resource "aws_route_table_association" "subnet1-assosciation" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.main.id
}


resource "aws_route_table_association" "subnet2-assosciation" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.main.id
}


resource "aws_eip" "eip_natgw_1" {
  vpc = aws_vpc.main.id

  tags = {
    Name = "Elastic IP - For NAT GW 1"
  }

}


resource "aws_eip" "eip_natgw_2" {
  vpc = aws_vpc.main.id

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