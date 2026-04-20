# Création du rôle I am
resource "aws_iam_role" "role_bucket_s3" {
  name = "${var.prefix_name}-s3-${var.nom_bucket}-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# Ajout de la politique de traduction (Module personnel ajouté qui était obligatoire)
resource "aws_iam_role_policy" "translate_policy" {
  name = "${var.prefix_name}-translate-policy"
  role = aws_iam_role.role_bucket_s3.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "translate:TranslateText",
          "translate:TranslateDocument"
        ]
        Resource = "*"
      }
    ]
  })
}

# Ajout de la politique d'accès au bucket à la VM 
resource "aws_iam_role_policy_attachment" "s3_access" {
  role       = aws_iam_role.role_bucket_s3.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# Politique qui permet à la VM EC2 d'accéder au bucket S3
resource "aws_iam_role_policy" "s3_bucket_policy" {
  name   = "${var.prefix_name}-s3-${var.nom_bucket}-policy"
  role   = aws_iam_role.role_bucket_s3.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "s3:*"
            ],
            "Resource": [
              "arn:aws:s3:::${var.nom_bucket}",
              "arn:aws:s3:::${var.nom_bucket}/*"
            ]
        }
    ]
}
EOF
}

# Créé un profil pour rattacher la politique à la VM
resource "aws_iam_instance_profile" "s3_profile" {
  name = "${var.prefix_name}-s3-profil"
  role = aws_iam_role.role_bucket_s3.name
}
