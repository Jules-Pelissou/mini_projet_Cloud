provider "aws" {
  region = var.region
}

module "vpc_mini_projet" {
    source                  = "./modules/vpc"
}

module "s3_mini_projet" {
    source                  = "./modules/s3"
    prefix_name             = var.prefix_name
}

module "role_s3_mini_projet" {
    source                  = "./modules/ec2_role_allow_s3"
    prefix_name             = var.prefix_name
    nom_bucket             = var.nom_bucket
}

module "elb_asg_mini_projet" {
  source = "./modules/elb_asg"
  iam_instance_profile = module.role_s3_mini_projet.instance_profile_name
  public_subnets  = module.vpc_mini_projet.public_subnet_ids
  private_subnets = module.vpc_mini_projet.private_subnet_ids
  ami_id  = data.aws_ami.ubuntu-ami.id
  key_name = "my-key" # ou aws_key_pair
  vpc_id = module.vpc_mini_projet.vpc_id


  prefix_name = var.prefix_name

  user_data = <<-EOF
    #!/bin/bash
    sudo apt-get update -y
    sudo apt-get install -y apache2 awscli mysql-client php php-mysql
    sudo systemctl start apache2
    sudo systemctl enable apache2
    sudo rm -f /var/www/html/index.html
    sudo aws s3 sync s3://${var.nom_bucket}/ /var/www/html/
    mysql -h ${module.bdd_mini_projet.host} -u ${module.bdd_mini_projet.username} -p${var.db_password} < /var/www/html/articles.sql
    sudo sed -i 's/##DB_HOST##/${module.bdd_mini_projet.host}/' /var/www/html/db-config.php
    sudo sed -i 's/##DB_USER##/${module.bdd_mini_projet.username}/' /var/www/html/db-config.php
    sudo sed -i 's/##DB_PASSWORD##/${var.db_password}/' /var/www/html/db-config.php
  EOF
}

module "bdd_mini_projet" {
  source                   = "./modules/rds"
  app_sg_id = module.elb_asg_mini_projet.app_sg_id
  prefix_name              = var.prefix_name
  private_subnet_ids       = module.vpc_mini_projet.private_subnet_ids
  storage_gb               = 5
  bdd_version          = "10.6"
  bdd_instance_type    = "db.t2.micro"
  db_username              = "test_user"
  db_password              = var.db_password
  is_multi_az              = true
  backup_retention_period  = 1
  vpc_id = module.vpc_mini_projet.vpc_id
}

module "cloudwatch_mini_projet" {
  source = "./modules/cloudwatch_cpu_alarms"

  prefix_name = var.prefix_name

  asg_name = module.elb_asg_mini_projet.asg_name

  min_cpu_percent_alarm = 5
  max_cpu_percent_alarm = 80
}

data "aws_ami" "ubuntu-ami" {
  most_recent = true

  owners = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}