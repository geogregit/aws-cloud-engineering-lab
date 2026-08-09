terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}
resource "aws_vpc" "cloud_lab_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name    = "cloud-engineering-lab-vpc"
    Project = "AWS-Cloud-Engineering-Lab"
  }
}
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.cloud_lab_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = true

  tags = {
    Name    = "cloud-lab-public-subnet-1"
    Project = "AWS-Cloud-Engineering-Lab"
  }
}
resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.cloud_lab_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-2b"
  map_public_ip_on_launch = true

  tags = {
    Name    = "cloud-lab-public-subnet-2"
    Project = "AWS-Cloud-Engineering-Lab"
  }
}
resource "aws_internet_gateway" "cloud_lab_igw" {
  vpc_id = aws_vpc.cloud_lab_vpc.id

  tags = {
    Name    = "cloud-lab-internet-gateway"
    Project = "AWS-Cloud-Engineering-Lab"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.cloud_lab_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cloud_lab_igw.id
  }

  tags = {
    Name    = "cloud-lab-public-route-table"
    Project = "AWS-Cloud-Engineering-Lab"
  }
}

resource "aws_route_table_association" "public_subnet_1_association" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_2_association" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}
resource "aws_security_group" "web_sg" {
  name        = "cloud-lab-web-sg"
  description = "Security group for cloud engineering lab web resources"
  vpc_id      = aws_vpc.cloud_lab_vpc.id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "cloud-lab-web-sg"
    Project = "AWS-Cloud-Engineering-Lab"
  }
}
