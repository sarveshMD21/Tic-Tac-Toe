terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"

    }
  }
}

provider "aws" {
 region                   = "us-east-1"
  profile                  = "default"
}

data "aws_availability_zones" "available" {}


module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.7.0"

  name                 = "sarvesh-eks-vpc"
  cidr                 = "10.0.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = ["10.0.6.0/24", "10.0.7.0/24"]
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
//  one_nat_gateway_per_az=false
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    "kubernetes.io/cluster/sarvesh-cluster" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/sarvesh-cluster" = "shared"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/sarvesh-cluster" = "shared"
  }
}

# resource "aws_internet_gateway" "eks_igw" {
#   vpc_id = module.vpc.vpc_id
# }

# resource "aws_eip" "eks_nat" {
#   vpc      = true
# }

# resource "aws_nat_gateway" "eks_nat" {
#   subnet_id     = module.vpc.public_subnets[0]
#   allocation_id = aws_eip.eks_nat.id
# }



# resource "aws_route" "route_to_igw" {
#   route_table_id         = module.vpc.private_route_table_ids[0]  # Assuming there's only one private route table
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id             = aws_internet_gateway.eks_igw.id
# }