resource "aws_vpc" "aws_rke2_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "aws-rke2-vpc"
  }
}

resource "aws_internet_gateway" "aws_rke2_igw" {
  vpc_id = aws_vpc.aws_rke2_vpc.id

  tags = {
    Name = "aws-rke2-igw"
  }
}

resource "aws_route_table" "aws_rke2_rtb" {
  vpc_id = aws_vpc.aws_rke2_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.aws_rke2_igw.id
  }

  tags = {
    Name = "aws-rke2-rtb"
  }
}

resource "aws_route_table_association" "aws_rke2_rta1" {
  subnet_id      = aws_subnet.aws_rke2_subnet.id
  route_table_id = aws_route_table.aws_rke2_rtb.id
}

resource "aws_subnet" "aws_rke2_subnet" {
  vpc_id            = aws_vpc.aws_rke2_vpc.id
  cidr_block        = var.subnet_cidr_block
  availability_zone = "${var.region}a"

  tags = {
    Name = "aws-rke2-subnet"
  }
}

resource "aws_security_group" "aws_rke2_sg" {
  vpc_id      = aws_vpc.aws_rke2_vpc.id
  description = "AWS RKE2 Security Group"
  name        = "aws-rke2-sg"

  tags = {
    Name = "aws-rke2-sg"
  }
}

resource "aws_security_group_rule" "aws_rke2_sg_ingress" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.aws_rke2_sg.id
  description       = "Allow All Ingress Communication"
}

resource "aws_security_group_rule" "aws_rke2_sg_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.aws_rke2_sg.id
  description       = "Allow All Egress Communication"
}