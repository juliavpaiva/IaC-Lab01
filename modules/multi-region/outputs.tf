output "public_ip" {
  value = aws_instance.server_amazon_linux[*].public_ip
}

output "arn" {
  value = aws_instance.server_amazon_linux[*].arn
}