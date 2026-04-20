output "host" {
  value = aws_db_instance.bdd.address
}

output "username" {
  value = aws_db_instance.bdd.username
}