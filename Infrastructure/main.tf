module "ecr" {
    source = "./modules/ecr"
}

module "ec2" {
  source             = "./modules/ec2"
  jenkins_sg_id      = module.security_groups.jenkins_sg_id
  subnet_id          = module.vpc.private_subnet_ids[0]
  ami_id             = var.jenkins_ami_id
  instance_type      = var.jenkins_instance_type
  key_name           = var.jenkins_key_name
}

module "vpc" {
    source = "./modules/vpc"
    vpc_cidr              = var.vpc_cidr
    azs                   = var.azs
    public_subnet_cidrs   = var.public_subnet_cidrs
    private_subnet_cidrs  = var.private_subnet_cidrs
}

module "security_groups" {
    source               = "./modules/security_groups"
    vpc_id               = module.vpc.vpc_id
    vpc_cidr             = module.vpc.vpc_cidr
    eks_cluster_sg_id    = module.eks.cluster_security_group_id
    allowed_jenkins_cidr = var.allowed_jenkins_cidr
    allowed_home_cidr    = var.allowed_home_cidr
    jenkins_sg_id        = module.ec2.jenkins_sg_id

}

module "eks" {
    source                  = "./modules/eks"
    cluster_name            = var.cluster_name
    cluster_role_arn        = module.iam.eks_cluster_role_arn
    node_role_arn           = module.iam.eks_node_role_arn
    subnet_ids              = module.vpc.private_subnet_ids
    node_security_group_id  = module.security_groups.eks_node_sg_id
    instance_type           = var.eks_instance_type
}

module "iam" {
  source = "./modules/iam"
}