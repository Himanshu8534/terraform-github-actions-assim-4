# VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

# Subnet
resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

# Route Table
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id
}

# Route
resource "aws_route" "route" {
  route_table_id         = aws_route_table.rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Route Association
resource "aws_route_table_association" "rta" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.rt.id
}

# Security Group
resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance
resource "aws_instance" "server" {
  ami           = "ami-006f82a1d5a27da54"
  instance_type = "t3.small"
  subnet_id     = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "Basic-EC2"
  }
}
