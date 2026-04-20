# Création du bucket
resource "aws_s3_bucket" "bucket_MP" {
  bucket = "bucket-mp-7899878"
  acl = "private"

  tags = {
    Name = "bucket_MP"
  }
}

# Pour ajouter les fichiers dans le bucket
resource "aws_s3_object" "app_files" {
  for_each = fileset("./app", "**/*")

  bucket = aws_s3_bucket.bucket_MP.id
  key    = each.value
  source = "./app/${each.value}"
}
