output "instance_public_ip" {
  description = "Endereço IP público da instância"
  value       = aws_instance.api.public_ip
}

output "api_health_url" {
  description = "URL para testar a saúde da API"
  value       = "http://${aws_instance.api.public_ip}:3000/health"
}
