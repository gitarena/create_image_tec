provider "aws" {
  region = "us-east-1"
  
  default_tags {
    tags = {
      Name        = "imagem_php74"
      CC          = "devops"
      Project     = "arena_linux"
      Environment = "prod"
      ManagedBy   = "Terraform"
    }
  }
}

#Save state in S3 bucket
terraform{
  backend "s3"{
    bucket   = "terraform-prod"
    key      = "cria_imagem_php74.tfstate"
    region   = "us-east-1"
    encrypt  = true
  }
}

data "aws_ami" "ubuntu" {
    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"] # Canonical
}

### Create Linux Instance in AWS
resource "aws_instance" "sistema" {
  ami                         = "${data.aws_ami.ubuntu.id}"
  instance_type               = "t3.micro"
  associate_public_ip_address = true
  key_name                    = "terraform-staging"
  subnet_id                   = "subnet-0bcccbb0ee091d427"
  vpc_security_group_ids      = ["sg-01067c07917d9645b"]
}