variable "prefix_name" {}

variable "private_subnet_ids" {
	type = list
}

# Stockage de la BD à 20 gigas
variable "storage_gb" {
  	default = 20
}

variable "app_sg_id" {
  type = string
}

variable "bdd_version" {
  default = "10.6"
}

# Type d'instance de la BD
variable "bdd_instance_type" {
	default     = "db.t2.micro"
}

# Normalement les laisser vides pour éviter les problèmes de sécurité
variable "db_username" {
    default = "test_user"
}

variable "db_password" {
    default = "123456789"
}

# Multi AZ activé 
variable "is_multi_az" {
	default = true
}

# Durée pendant laquelle on garde une backup des données
variable "backup_retention_period" {
	default     = 1
}

variable "vpc_id" {
  type = string
}