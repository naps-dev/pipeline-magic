terraform {
  required_version = "= 1.3.4"

  backend "s3" {
    bucket         = "pipeline-magic-state"
    key            = "global/pl-runner/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "pipeline-magic-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source    = "cloudposse/vpc/aws"
  version   = "2.0.0"
  namespace = "test"
  stage     = "test"
  name      = "pl-runner"

  ipv4_primary_cidr_block          = "10.0.72.0/24"
  assign_generated_ipv6_cidr_block = false
}

module "dynamic_subnets" {
  source             = "cloudposse/dynamic-subnets/aws"
  version            = "2.0.4"
  namespace          = "test"
  stage              = "test"
  availability_zones = ["us-east-1a", "us-east-1b"]
  vpc_id             = module.vpc.vpc_id
  igw_id             = [module.vpc.igw_id]
  ipv4_cidr_block    = ["10.0.72.0/24"]
}

resource "aws_security_group" "pl_runner_sg" {
  vpc_id = module.vpc.vpc_id

  # Allow SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all egress
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "pl-runner-sg"
  }
}

resource "tls_private_key" "pl_magic" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "cloud_pem" {
  filename        = "runner.pem"
  file_permission = "0400"
  content         = tls_private_key.pl_magic.private_key_pem
}

resource "aws_key_pair" "generated_key" {
  key_name   = "pl-magic"
  public_key = tls_private_key.pl_magic.public_key_openssh
}

resource "aws_network_interface" "pl_runner" {
  subnet_id       = module.dynamic_subnets.public_subnet_ids[0]
  security_groups = [aws_security_group.pl_runner_sg.id]
}

resource "aws_instance" "pl_runner" {
  instance_type = var.instance_type
  ami           = var.runner_amis[var.aws_region]

  key_name = aws_key_pair.generated_key.id

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.pl_runner.id
  }

  root_block_device {
    encrypted   = true
    volume_type = "gp2"
    volume_size = 1000
  }

  tags = {
    Name = "pl-runner"
  }
}
