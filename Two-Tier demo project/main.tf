module "vpc" {
  source = "./modules/vpc"
  cidr_block = "10.0.0.0/16"
  cidr_blocks_pub_sub = [ "10.0.1.0/24", "10.0.2.0/24" ]
  cidr_blocks_priv_sub = [ "10.0.3.0/24", "10.0.4.0/24" ]
}

module "alb" {
  source = "./modules/alb"
  vpc_id = module.vpc.vpc_id
  alb_subnets = module.vpc.alb_subnets
}

module "asg" {
  source = "./modules/asg"
  alb_sg_id = module.alb.sg_id
  subnet_ids = module.vpc.instance_subnets
  target_group_arn = module.alb.target_group_arn
  vpc_id = module.vpc.vpc_id
  desired_capacity = 2
  min_size = 2
  max_size = 4
}

