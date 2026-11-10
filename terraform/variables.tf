variable "aws_region" {
  description = "Região AWS onde os recursos serão criados"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nome usado para identificar os recursos"
  type        = string
  default     = "api-catalogo-series"
}

variable "instance_type" {
  description = "Tipo da instância EC2"
  type        = string
  default     = "t3.micro"
}

variable "admin_cidr" {
  description = "IP público autorizado a acessar SSH, no formato CIDR"
  type        = string
  default     = "127.0.0.1/32"
}

variable "github_repo_url" {
  description = "URL HTTPS do repositório público no GitHub"
  type        = string
}
