provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.0/24"

}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}


resource "aws_route_table_association" "main" {
  route_table_id = aws_route_table.main.id
  subnet_id      = aws_subnet.main.id
}

resource "aws_security_group" "allow_http" {
  name   = "allow_http"
  vpc_id = aws_vpc.main.id
}

resource "aws_vpc_security_group_ingress_rule" "main" {
  security_group_id = aws_security_group.allow_http.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = "80"
  to_port           = "80"
}

resource "aws_vpc_security_group_egress_rule" "main" {
  security_group_id = aws_security_group.allow_http.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_eip" "main" {
  domain = "vpc"
}

resource "aws_eip_association" "main" {
  allocation_id = aws_eip.main.id
  instance_id   = aws_instance.main.id
}

resource "aws_instance" "main" {
  instance_type = "t2.micro"
  ami           = "ami-0b6d9d3d33ba97d99"
  subnet_id     = aws_subnet.main.id

  associate_public_ip_address = true

  vpc_security_group_ids = [
    aws_security_group.allow_http.id
  ]

  iam_instance_profile = aws_iam_instance_profile.ec2_ssm.name
}

terraform {
  backend "s3" {
    bucket = "xheyi-new-project-terraform-state"
    key    = "new-project/terraform.tfstate"
    region = "us-east-1"
  }
}