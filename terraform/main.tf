terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_security_group" "api" {
  name        = "${var.project_name}-sg"
  description = "Acesso HTTP da API e SSH administrativo"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "API Node.js"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH - restrinja para o seu IP antes de aplicar"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.admin_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-sg"
  }
}

resource "aws_instance" "api" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = data.aws_subnets.default.ids[0]
  vpc_security_group_ids      = [aws_security_group.api.id]
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    set -e
    apt-get update
    apt-get install -y ca-certificates curl git
    curl -fsSL https://deb.nodesource.com/setup_22.x | bash -
    apt-get install -y nodejs
    cd /opt
    git clone ${var.github_repo_url} catalogo-series
    cd /opt/catalogo-series
    npm install --omit=dev
    cat > /etc/systemd/system/catalogo-series.service <<'SERVICE'
    [Unit]
    Description=API Catalogo de Series
    After=network.target

    [Service]
    WorkingDirectory=/opt/catalogo-series
    ExecStart=/usr/bin/node src/server.js
    Restart=always
    Environment=PORT=3000
    User=ubuntu

    [Install]
    WantedBy=multi-user.target
    SERVICE
    chown -R ubuntu:ubuntu /opt/catalogo-series
    systemctl daemon-reload
    systemctl enable catalogo-series
    systemctl start catalogo-series
  EOF

  tags = {
    Name = var.project_name
  }
}
