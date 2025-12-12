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

module "images" {
  source      = "./modules/s3_images"
  env         = var.env
  project     = "illuminati"
  common_tags = var.common_tags
}

module "lambda" {
  source             = "./modules/lambda"
  env                = var.env
  unsplash_key       = var.lambda.unsplash_key
  birdwatch_url      = var.lambda.birdwatch_url
  mail_service       = var.lambda.mail_service
  illuminati_backend = var.lambda.illuminati_backend
  zip_file_path      = var.lambda.zip_file_path
  unsplash_url       = var.lambda.unsplash_url
  ebird_api_key      = var.lambda.ebird_api_key
  ebird_url          = var.lambda.ebird_url
}
