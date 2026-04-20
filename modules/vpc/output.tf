output "vpc_id" {
  value = aws_vpc.VPC_MiniProjet.id
}

output "public_subnet_ids" {
  value = [
    aws_subnet.Subnet_MP_public_1.id,
    aws_subnet.Subnet_MP_public_2.id
  ]
}

output "private_subnet_ids" {
  value = [
    aws_subnet.Subnet_MP_prive_1.id,
    aws_subnet.Subnet_MP_prive_2.id
  ]
}