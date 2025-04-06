# VPC and Networking Resources

resource "aws_vpc" "my_vpc" {
  cidr_block       = var.cidr_block
  instance_tenancy = var.instance_tenancy

  tags = { Name = "main" }
}

# Internet Gateway 

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = { Name = "igw" }
}

# Public Subnets 

resource "aws_subnet" "public1a" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.cidr_block_public1a
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = { Name = "public1a" }
}

resource "aws_subnet" "public1b" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.cidr_block_public1b
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true

  tags = { Name = "public1b" }
}

# Private Subnets 

resource "aws_subnet" "private1a" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.cidr_block_private1a
  availability_zone       = "ap-south-1a"  # Fixed AZ mismatch
  map_public_ip_on_launch = false

  tags = { Name = "private1a" }
}

resource "aws_subnet" "private1b" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.cidr_block_private1b
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = false

  tags = { Name = "private1b" }
}

# Public Route Tables

resource "aws_route_table" "publicRT1a" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = { Name = "PublicRouteTable1a" }
}

resource "aws_route_table" "publicRT1b" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = { Name = "PublicRouteTable1b" }
}

# Route Table Associations (Public) 

resource "aws_route_table_association" "public1a_assoc" {
  subnet_id      = aws_subnet.public1a.id
  route_table_id = aws_route_table.publicRT1a.id
}

resource "aws_route_table_association" "public1b_assoc" {
  subnet_id      = aws_subnet.public1b.id
  route_table_id = aws_route_table.publicRT1b.id
}

# NAT Gateways (HA Setup) 

# Elastic IPs
resource "aws_eip" "nat_eip_1a" { domain = "vpc" }
resource "aws_eip" "nat_eip_1b" { domain = "vpc" }

# NAT Gateway in ap-south-1a
resource "aws_nat_gateway" "nat_1a" {
  allocation_id = aws_eip.nat_eip_1a.id
  subnet_id     = aws_subnet.public1a.id

  tags = { Name = "NAT-GW-1a" }
}

# NAT Gateway in ap-south-1b
resource "aws_nat_gateway" "nat_1b" {
  allocation_id = aws_eip.nat_eip_1b.id
  subnet_id     = aws_subnet.public1b.id

  tags = { Name = "NAT-GW-1b" }
}

# Private Route Tables 

resource "aws_route_table" "privateRT1a" {
  vpc_id = aws_vpc.my_vpc.id
  tags   = { Name = "PrivateRouteTable1a" }
}

resource "aws_route_table" "privateRT1b" {
  vpc_id = aws_vpc.my_vpc.id
  tags   = { Name = "PrivateRouteTable1b" }
}

# Private Route Table Associations

resource "aws_route_table_association" "private1a_assoc" {
  subnet_id      = aws_subnet.private1a.id
  route_table_id = aws_route_table.privateRT1a.id
}

resource "aws_route_table_association" "private1b_assoc" {
  subnet_id      = aws_subnet.private1b.id
  route_table_id = aws_route_table.privateRT1b.id
}

# NAT Routes for Private Subnets

resource "aws_route" "privateRT1a_nat" {
  route_table_id         = aws_route_table.privateRT1a.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_1a.id
}

resource "aws_route" "privateRT1b_nat" {
  route_table_id         = aws_route_table.privateRT1b.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_1b.id
}