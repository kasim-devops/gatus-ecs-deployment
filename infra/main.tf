module "vpc" {
  source                  = "./modules/vpc"
  availability_zone_names = ["eu-west-2a", "eu-west-2b"]
  public_subnet_cidrs     = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs    = ["10.0.5.0/24", "10.0.6.0/24"]
}

module "security-groups" {
  source = "./modules/security-groups"
  vpc_id = module.vpc.vpc_id
}

module "acm" {
  source            = "./modules/acm"
  domain_name       = var.domain_name
  route53_zone_name = var.route53_zone_name
}

module "alb" {
  source                = "./modules/alb"
  public_subnet_ids     = module.vpc.public_subnet_ids
  alb_security_group_id = module.security-groups.alb_security_group_id
  vpc_id                = module.vpc.vpc_id
  certificate_arn       = module.acm.certificate_arn
  route53_zone_name     = var.route53_zone_name
  app_domain_name       = var.domain_name
}

module "ecs" {
  source                = "./modules/ecs"
  private_subnet_ids    = module.vpc.private_subnet_ids
  ecs_security_group_id = module.security-groups.ecs_security_group_id
  target_group_arn      = module.alb.target_group_arn
  desired_count         = 1
  cpu                   = 256
  memory                = 512
  gatus_image           = var.gatus_image
  aws_region            = var.aws_region
}