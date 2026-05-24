provider "aws" {
  # Bölge .env dosyasındaki AWS_DEFAULT_REGION üzerinden veya varsayılan olarak us-east-1 ayarlanır
  region = "us-east-1"
}

# 1. Zafiyet: Herkese Açık (Public) S3 Bucket
resource "aws_s3_bucket" "vulnerable_bucket" {
  bucket = "my-devsecops-vulnerable-bucket-ai-demo" # Bucket isimleri AWS genelinde benzersiz olmalıdır
}

resource "aws_s3_bucket_public_access_block" "vulnerable_bucket_access" {
  bucket = aws_s3_bucket.vulnerable_bucket.id

  # DİKKAT: Gerçek dünyada bunların hepsi 'true' olmalıdır!
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# 2. Zafiyet: Dünyaya Açık (0.0.0.0/0) Security Group
resource "aws_security_group" "vulnerable_sg" {
  name        = "vulnerable-sg-demo"
  description = "Security group with completely open SSH and HTTP ports"

  # SSH Portu (22) herkese açık
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  # HTTP Portu (80) herkese açık
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
