variable "node_group_iam_role_additional_policies" {
  type        = map(string)
  description = "List of IAM policy ARNs to attach to the EKS node group role"
  default     = {
    policy1="arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    policy2="arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    policy3="arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    policy4="arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy",
    policy5="arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
    # Add more policies as needed
  }
}

variable "eks_iam_role_additional_policies" {
    type        = map(string)
  description = "List of IAM policy ARNs to attach to the EKS cluster"
  default     = {
    policy1="arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    # Add more policies as needed
  }
}