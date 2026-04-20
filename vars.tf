variable "region" {
  default = "us-east-1"
}

variable "prefix_name" {
  default = "app-mini-projet"
}

variable db_password {
  type        = string
  default     = "123456789"
  description = "Normalement ne pas l'afficher pour éviter pbs de sécu"
}

variable "nom_bucket" {
  type = string
  default ="bucket_MP"
}
