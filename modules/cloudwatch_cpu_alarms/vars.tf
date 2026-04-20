variable "prefix_name" {}

variable "asg_name" {}

variable "nom_autoscale" {
  type        = string
  default     = "autosacle_test"
}


variable "min_cpu_percent_alarm" {
  default = 5
}

variable "max_cpu_percent_alarm" {
  default = 80
}