provider "aws" {
  region = "us-east-1"
}

# 1. S3 BUCKET VE GÜVENLİK AYARLARI (GÜVENLİ)
resource "aws_s3_bucket" "vulnerable_bucket" {
  bucket = "my-secure-production-bucket-demo-xyz" 
}

resource "aws_s3_bucket_public_access_block" "vulnerable_bucket_access" {
  bucket = aws_s3_bucket.vulnerable_bucket.id

  # Tüm public erişim engelleme kuralları 'true' yapılmıştır.
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# 2. SECURITY GROUP VE SSH ERİŞİM AYARLARI (GÜVENLİ)
resource "aws_security_group" "vulnerable_sg" {
  name        = "secure-ssh-sg-demo"
  description = "SSH and HTTP access restricted to trusted networks only"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["192.168.1.0/24"] # Sadece şirket içi IP'ye izin verildi
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["192.168.1.0/24"] # HTTP de sadece şirket içi IP'ye sınırlandırıldı
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
