terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 3.0"
        }
    }
}

#configure provider
provider "aws" {
    region = var.region
    profile = "app1"
}

locals {
  env = terraform.workspace

  counts = {
      "dev" = 3
      "prod" = 6
  }
  instances = {
      "dev" = "t2.micro"
      "prod" = "t4.large"
  }

}
#DATA
data "aws_availability_zones" "available" {}

data "aws_ami" "aws-linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

#Resources
resource "random_id" "rand_id" {
    byte_length = 8
}
resource "random_id" "unq_id" {
    byte_length = 8
}
# vpc resource
resource "aws_vpc" "vpcs" {
    
    cidr_block = var.cidr_blocks["public1"]
        tags = {
            Name = var.prefix
    }
}
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpcs.id
  
}
#Subnet
resource "aws_subnet" "subnet" {
    vpc_id = aws_vpc.vpcs.id
    count = var.subnet_count
    cidr_block = cidrsubnet(var.cidr_blocks["public1"], 8, count.index)
    map_public_ip_on_launch = true
    availability_zone = data.aws_availability_zones.available.names[count.index]
  
}
#db subnets
resource "aws_subnet" "dbsubnet" {
    vpc_id = aws_vpc.vpcs.id
    cidr_block = var.cidr_blocks["private1"]
    map_public_ip_on_launch = false
    availability_zone = data.aws_availability_zones.available.names[0]
    tags = {
        Name = "${var.prefix}-db-prv-0-subnet"
    }
}

resource "aws_subnet" "dbsubnet1" {
    vpc_id = aws_vpc.vpcs.id
    cidr_block = var.cidr_blocks["private2"]
    map_public_ip_on_launch = false
    availability_zone = data.aws_availability_zones.available.names[1]
    tags = {
        Name = "${var.prefix}-db-prv-1-subnet"
    }
}

resource "aws_db_subnet_group" "postgresdb_subnet_group" {
name = "postgresdb_subnet_group"
description = "postgresdb_subnet_group"
subnet_ids = [aws_subnet.dbsubnet.id,aws_subnet.dbsubnet1.id]
  tags = {
    Name = "MyDBSubnetGroup_Postgres"
  }
}
#Route Table
resource "aws_route_table" "rtb" {
    vpc_id = aws_vpc.vpcs.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
  tags = {
    Name = var.prefix
  }
}

resource "aws_route_table_association" "rta_subnet" {
    count = var.subnet_count
    subnet_id = aws_subnet.subnet[count.index].id
    route_table_id = aws_route_table.rtb.id
  
}
#Security Group for Ngnix EC2
resource "aws_security_group" "nginx-sg" {
    name = "nginx_sg"
    vpc_id = aws_vpc.vpcs.id
    #SSH Access from Anywhere
    ingress  {
      cidr_blocks = ["0.0.0.0/0"]
      description = "ssh"
      from_port = 22
      protocol = "tcp"
      to_port = 22
    } 
   #Allow HTTP from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# INSTANCES #
resource "aws_instance" "nginx" {
  count                  = var.instance_count
  ami                    = data.aws_ami.aws-linux.id
  instance_type          = lookup(local.instances,local.env)
  subnet_id              = aws_subnet.subnet[count.index % var.subnet_count].id
  vpc_security_group_ids = [aws_security_group.nginx-sg.id]
  key_name               = var.key_name
  tags = {
    Name = var.prefix
  }
}

module "ec2_cluster" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "~> 2.12.0"

  name                   = "my-cluster"
  instance_count         = 2
  count                  = 1
  ami                    = data.aws_ami.aws-linux.id
  instance_type          = "t2.micro"
  key_name               = var.key_name
  monitoring             = true
  vpc_security_group_ids = [aws_security_group.nginx-sg.id]
  subnet_id              = aws_subnet.subnet[count.index % var.subnet_count].id

  tags = {
    Terraform   = "true"
    Environment = "${var.prefix}-ec2_cluster"
  }
}

module postgres_db {
    source = "./modules/rds"
    db_name = var.database_name
    db_user_name = var.database_username
    db_password = var.database_password
    database_subnet_group_name = aws_db_subnet_group.postgresdb_subnet_group.name
    postgres_tags = {
        Terraform = "true"
        Name = "${var.prefix}-postgres_cluster"

    }
    
}
# outputs
 output "vpc_ids" {
  value = aws_vpc.vpcs.id

  }
  output "ec2_cluster_public_ips" {
  description = "Public IP addresses of EC2 instances"
  value       = module.ec2_cluster[*].public_ip
}