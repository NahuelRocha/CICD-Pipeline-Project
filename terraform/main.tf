provider "aws" {
  region                      = "ap-south-1"
  access_key                  = "mock_access_key"
  secret_key                  = "mock_secret_key"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true

  endpoints {
    ec2            = "http://172.24.126.69:4566"
    iam            = "http://172.24.126.69:4566"
    sts            = "http://172.24.126.69:4566"
    vpc            = "http://172.24.126.69:4566"
  }
}

resource "aws_vpc" "pipeline_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = { Name = "pipeline-vpc" }
}

resource "aws_subnet" "pipeline_subnet" {
  count                   = 2
  vpc_id                  = aws_vpc.pipeline_vpc.id
  cidr_block              = cidrsubnet(aws_vpc.pipeline_vpc.cidr_block, 8, count.index)
  availability_zone       = element(["ap-south-1a", "ap-south-1b"], count.index)
  map_public_ip_on_launch = true
  tags = { Name = "pipeline-subnet-${count.index}" }
}

resource "aws_internet_gateway" "pipeline_igw" {
  vpc_id = aws_vpc.pipeline_vpc.id
  tags = { Name = "pipeline-igw" }
}

resource "aws_route_table" "pipeline_route_table" {
  vpc_id = aws_vpc.pipeline_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.pipeline_igw.id
  }
  tags = { Name = "pipeline-route-table" }
}

resource "aws_route_table_association" "subnet_association" {
  count          = 2
  subnet_id      = aws_subnet.pipeline_subnet[count.index].id
  route_table_id = aws_route_table.pipeline_route_table.id
}

resource "aws_security_group" "app_sg" {
  name   = "app-sg"
  vpc_id = aws_vpc.pipeline_vpc.id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}