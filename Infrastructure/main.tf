module "ecr" {
    source = "./modules/ecr"
}

module "ec2" {
    source = "./modules/ec2"
    jenkins_sg_id   = module.security_groups.jenkins_sg_id
    subnet_id       = module.vpc.private_subnet_ids[0]
}

module "vpc" {
    source = "./modules/vpc"
    vpc_cidr  = "10.0.0.0/16"
    azs       = ["eu-west-1a", "eu-west-1b"]
    private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]
}

module "security_groups" {
    source = "./modules/security_groups"
    vpc_id = module.vpc.vpc_id
    
    eks_cluster_sg_id = module.eks.cluster_security_group_id
    jenkins_sg_id     = module.security_groups.jenkins_sg_id
    vpc_cidr          = module.vpc.vpc_cidr 
}

module "eks" {
  source            = "./modules/eks"
  cluster_name      = "Tomas-EKS-cluster"
  cluster_role_arn  = module.iam.eks_cluster_role_arn
  node_role_arn     = module.iam.eks_node_role_arn
  subnet_ids        = module.vpc.private_subnet_ids
}

module "iam" {
  source = "./modules/iam"
}