# Création du VPC

resource "aws_vpc" "VPC_MiniProjet" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "MiniProjet-vpc"
  }
}

# Création des sous réseaux (publics et privés)

resource "aws_subnet" "Subnet_MP_public_1" {
  vpc_id                  = aws_vpc.VPC_MiniProjet.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = {
    Name = "Subnet_MP_public_1"
  }
}

resource "aws_subnet" "Subnet_MP_public_2" {
  vpc_id                  = aws_vpc.VPC_MiniProjet.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"
  tags = {
    Name = "Subnet_MP_public_2"
  }
}


resource "aws_subnet" "Subnet_MP_prive_1" {
  vpc_id                  = aws_vpc.VPC_MiniProjet.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1b"
  tags = {
    Name = "Subnet_MP_prive_1"
  }
}


resource "aws_subnet" "Subnet_MP_prive_2" {
  vpc_id                  = aws_vpc.VPC_MiniProjet.id
  cidr_block              = "10.0.4.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1a"
  tags = {
    Name = "Subnet_MP_prive_2"
  }
}

# Création de la gateway internet

resource "aws_internet_gateway" "Internet_Gateway_MP" {
  vpc_id = aws_vpc.VPC_MiniProjet.id

  tags = {
    Name = "Internet_Gateway_MP"
  }
}

# Création de l'Elastic IP pour le NAT

resource "aws_eip" "EIP_MP" {
  domain = "vpc"
  tags = {
    Name = "EIP_MP"
  }
}

# Création du NAT gateway

resource "aws_nat_gateway" "NAT_MP" {
  allocation_id = aws_eip.EIP_MP.id
  subnet_id     = aws_subnet.Subnet_MP_public_1.id
  tags = {
    Name = "NAT_MP"
  }
}

# Table routage publique

resource "aws_route_table" "RT_public_MP" {
  vpc_id = aws_vpc.VPC_MiniProjet.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Internet_Gateway_MP.id
  }

  tags = {
    Name = "RT_public_MP"
  }
}

# Table de routage privée

resource "aws_route_table" "RT_prive_MP" {
  vpc_id = aws_vpc.VPC_MiniProjet.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NAT_MP.id
  }

  tags = {
    Name = "RT_prive_MP"
  }
}

# Reliage des sous réseaux publics avec la table de routage publique

resource "aws_route_table_association" "RTA_public_1" {
  subnet_id      = aws_subnet.Subnet_MP_public_1.id
  route_table_id = aws_route_table.RT_public_MP.id
}

resource "aws_route_table_association" "RTA_public_2" {
  subnet_id      = aws_subnet.Subnet_MP_public_2.id
  route_table_id = aws_route_table.RT_public_MP.id
}

# Reliage des sous réseaux privés avec la table de routage privée

resource "aws_route_table_association" "RTA_prive_1" {
  subnet_id      = aws_subnet.Subnet_MP_prive_1.id
  route_table_id = aws_route_table.RT_prive_MP.id
}

resource "aws_route_table_association" "RTA_prive_2" {
  subnet_id      = aws_subnet.Subnet_MP_prive_2.id
  route_table_id = aws_route_table.RT_prive_MP.id
}