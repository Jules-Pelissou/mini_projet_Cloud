# Groupe de sécu pour la BD
resource "aws_security_group" "security-group-bdd" {
  vpc_id            = var.vpc_id
  name              = "${var.prefix_name}-sg-database"
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.app_sg_id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    self        = true
  }
}

# Mise de la bd dans des sous réseaux (sous réseaux du VPC)
resource "aws_db_subnet_group" "sr-bdd" {
  name        = "sr-bdd"
  description = "RDS groupe de sous réseaux"
  subnet_ids  = var.private_subnet_ids
}

# Params de la BDD
resource "aws_db_parameter_group" "params-bdd" {
  name        = "bdd-params"
  family      = "mariadb10.6"
}

# BDD
resource "aws_db_instance" "bdd" {
  allocated_storage         = var.storage_gb
  engine                    = "mariadb"
  engine_version            = var.bdd_version
  instance_class            = var.bdd_instance_type
  identifier                = "bdd"
  username                  = var.db_username
  password                  = var.db_password
  db_subnet_group_name      = aws_db_subnet_group.sr-bdd.name
  parameter_group_name      = aws_db_parameter_group.params-bdd.name
  multi_az                  = var.is_multi_az
  vpc_security_group_ids    = [aws_security_group.security-group-bdd.id]
  backup_retention_period   = var.backup_retention_period
  publicly_accessible = false
}