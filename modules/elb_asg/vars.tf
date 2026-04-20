variable "prefix_name" {}

variable "ami_id" {
  description = "AMI utilisée pour les instances (non présent pour éviter pbs de sécurité)"
}

variable "key_name" {
  description = "Nom de la clé SSH (non présent idem que pour l'ami)"
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "user_data" {}

variable "vpc_id" {
  type = string
}

variable "iam_instance_profile" {
  type = string
}