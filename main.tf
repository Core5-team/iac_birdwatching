module "lb" {
  source = "./modules/lb"

  vpc_id            = var.vpc_id
  igw_id            = var.igw_id
  availability_zone = var.availability_zone
  common_tags       = var.common_tags
  env               = var.env

  ami                = var.lb.ami
  instance_type      = var.lb.instance_type
  key_name           = var.lb.key_name
  dns_name           = var.lb.dns_name
  public_subnet_cidr = var.lb.public_subnet_cidr
}

module "web" {
  source = "./modules/web"

  vpc_id            = var.vpc_id
  availability_zone = var.availability_zone
  common_tags       = var.common_tags
  env               = var.env

  ami                     = var.web.ami
  instance_type           = var.web.instance_type
  key_name                = var.web.key_name
  private_web_subnet_cidr = var.web.private_web_subnet_cidr
  nat_gateway_id          = module.lb.nat_gateway_id
  allowed_cidrs           = [module.lb.security_group_id]
}

module "db" {
  source = "./modules/db"

  vpc_id            = var.vpc_id
  availability_zone = var.availability_zone
  common_tags       = var.common_tags
  env               = var.env

  ami            = var.db.ami
  instance_type  = var.db.instance_type
  key_pair       = var.db.key_pair
  db_subnet_cidr = var.db.db_subnet_cidr
  nat_gateway_id = module.lb.nat_gateway_id
  allowed_cidrs  = [module.web.security_group_id]
}

