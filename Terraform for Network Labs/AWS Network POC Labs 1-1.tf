# sydney POC

# Provider Block
provider "aws" {
  profile = "POC-tokyo" # AWS Credentials Profile configured on your local desktop terminal  $HOME/.aws/credentials
  region  = "ap-northeast-3"
}

# Define the CIDR blocks for the three VPCs
variable "vpc_cidr_blocks" {
  type    = list(string)
  default = ["10.0.0.0/16", "10.1.0.0/16", "10.2.0.0/16"]
}

# Create three VPCs
resource "aws_vpc" "vpc" {
  count       = length(var.vpc_cidr_blocks)
  cidr_block  = var.vpc_cidr_blocks[count.index]
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "VPC-${count.index}"
    Environment = "RAV-POC"
  }
}

# Create subnets in each VPC labeled as "SubnetA"
resource "aws_subnet" "subnetA" {
  count = length(var.vpc_cidr_blocks)
  vpc_id = aws_vpc.vpc[count.index].id
  cidr_block = cidrsubnet(var.vpc_cidr_blocks[count.index], 8, count.index * 2) # Generate unique CIDR blocks for SubnetA

  tags = {
    Name = "SubnetA-${count.index}"
    Environment = "RAV-POC"
  }
}

# Create subnets in each VPC labeled as "SubnetB"
resource "aws_subnet" "subnetB" {
  count = length(var.vpc_cidr_blocks)
  vpc_id = aws_vpc.vpc[count.index].id
  cidr_block = cidrsubnet(var.vpc_cidr_blocks[count.index], 8, (count.index * 2) + 1) # Generate unique CIDR blocks for SubnetB

  tags = {
    Name = "SubnetB-${count.index}"
    Environment = "RAV-POC"
  }
}



# Create an internet gateway for each VPC
resource "aws_internet_gateway" "igw" {
  count = length(aws_vpc.vpc)
  vpc_id = aws_vpc.vpc[count.index].id

  tags = {
    Name = "IGW-${count.index}"
    Environment = "RAV-POC"
  }
}

# Create a security group to allow SSH access
resource "aws_security_group" "allow_ssh" {
  count       = 3
  name = "allow-ssh-${var.vpc_cidr_blocks[count.index]}"
  description = "Allow SSH traffic"
  vpc_id      = aws_vpc.vpc[count.index].id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SecurityGroup-${count.index}"
    Environment = "RAV-POC"
  }
}

# Create an EC2 instance in each VPC and associate with subnets
resource "aws_instance" "ec2_instance" {
  count         = 3
  ami           = "ami-04b4d38c86a77bccc" # Replace with your desired AMI ID
  instance_type = "t3.micro"          # Choose an appropriate instance type
  subnet_id     = aws_subnet.subnetA[count.index].id # Associate with subnets
  security_groups = [aws_security_group.allow_ssh[count.index].id]

  tags = {
    Name = "EC2-Instance-${count.index}"
    Environment = "POC"
  }
}
