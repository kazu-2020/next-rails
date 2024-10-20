resource "aws_vpc" "main" {
  cidr_block           = "192.168.0.0/20"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

####################
# Subnet
####################
resource "aws_subnet" "public_alb_primary" {
  vpc_id            = aws_vpc.main.id
  availability_zone = "ap-northeast-1a"
  cidr_block        = "192.168.0.0/25"

  tags = {
    Public = true
  }
}

resource "aws_subnet" "public_alb_secondary" {
  vpc_id            = aws_vpc.main.id
  availability_zone = "ap-northeast-1c"
  cidr_block        = "192.168.0.128/25"
}
