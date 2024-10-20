resource "aws_vpc" "main" {
  cidr_block           = "192.168.0.0/20"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

####################
# Subnet
####################
resource "aws_subnet" "public_alb_primary" {
  vpc_id            = aws_vpc.main.id
  availability_zone = "ap-northeast-1a"
  cidr_block        = "192.168.0.0/25"

  tags = {
    Name   = "public_alb_primary"
    Public = true
  }
}

resource "aws_subnet" "public_alb_secondary" {
  vpc_id            = aws_vpc.main.id
  availability_zone = "ap-northeast-1c"
  cidr_block        = "192.168.0.128/25"

  tags = {
    Name   = "public_alb_secondary"
    Public = true
  }
}

resource "aws_subnet" "public_app_primary" {
  vpc_id            = aws_vpc.main.id
  availability_zone = "ap-northeast-1a"
  cidr_block        = "192.168.1.0/25"
  tags = {
    Name   = "public_app_primary"
    Public = true
  }
}

resource "aws_subnet" "public_app_secondary" {
  vpc_id            = aws_vpc.main.id
  availability_zone = "ap-northeast-1c"
  cidr_block        = "192.168.1.128/25"

  tags = {
    Name   = "public_app_secondary"
    Public = true
  }
}

####################
# Route Table
####################
resource "aws_route_table" "internet" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = aws_vpc.main.cidr_block
    gateway_id = "local"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "internet"
  }
}

resource "aws_route_table_association" "internet_with_public_alb_primary" {
  subnet_id      = aws_subnet.public_alb_primary.id
  route_table_id = aws_route_table.internet.id
}

resource "aws_route_table_association" "internet_with_public_alb_secondary" {
  subnet_id      = aws_subnet.public_alb_secondary.id
  route_table_id = aws_route_table.internet.id
}

resource "aws_route_table_association" "internet_with_public_app_primary" {
  subnet_id      = aws_subnet.public_app_primary.id
  route_table_id = aws_route_table.internet.id

}

resource "aws_route_table_association" "internet_with_public_app_secondary" {
  subnet_id      = aws_subnet.public_app_secondary.id
  route_table_id = aws_route_table.internet.id
}
