# vpc
resource "aws_vpc" "vpc_ec2" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "vpc_ec2_network"
  }
}

# igw
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc_ec2.id

  tags = {
    Name = "vpc_ec2_network_gateway"
  }
}

# gw attachment Not needed bcos d gw has already done this

# public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc_ec2.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1e"

  tags = {
    Name = "vpc_ec2_network_public_subnet"
  }
}

# route table
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.vpc_ec2.id

  tags = {
    Name = "vpc_ec2_network_rt"
  }
}

# route
resource "aws_route" "route" {
  route_table_id         = aws_route_table.rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

#route table association
resource "aws_route_table_association" "rt_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.rt.id
}


# outputs
output "vpc_ec2" {
  value       = aws_vpc.vpc_ec2
  sensitive   = false
  description = "A reference to the created VPC"
}

output "public_subnet" {
  value       = aws_subnet.public_subnet
  sensitive   = false
  description = "A reference to the created VPC"
}