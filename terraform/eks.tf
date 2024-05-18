module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "20.8.4"
  cluster_name    = "sarvesh-cluster"
  cluster_version = "1.27"
  subnet_ids      = module.vpc.private_subnets

  enable_irsa = true
  iam_role_additional_policies=var.eks_iam_role_additional_policies
  tags = {
    cluster = "demo"
  }
  
  vpc_id = module.vpc.vpc_id
  cluster_additional_security_group_ids=[aws_security_group.eks_security_group.id]
  eks_managed_node_group_defaults = {
    instance_types         = ["t2.micro"]
    vpc_security_group_ids = [aws_security_group.all_worker_mgmt.id]
  }

  eks_managed_node_groups = {
     node_group = {
      min_size     = 1
      max_size     = 3
      desired_size = 1
      subnets      = module.vpc.private_subnets
      tags         = {
        Environment = "production"
        NodeGroup    = "eks-nodes"
      }
      iam_role_additional_policies = var.node_group_iam_role_additional_policies
    }
  }
  
}



# resource "aws_iam_role_policy_attachment" "cluster_policy_attachment" {
#   role       = module.eks.cluster_iam_role_name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
# }

# resource "aws_iam_role_policy_attachment" "node_group_policy_attachments" {
#   count = length(var.node_group_policies)

#   role       = each.value.iam_role_name 
#   policy_arn = var.node_group_policies[count.index]
# }