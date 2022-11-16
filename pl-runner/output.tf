output "private_key" {
  value     = tls_private_key.pl_magic.private_key_pem
  sensitive = true
}

output "runner_ip" {
  value = aws_instance.pl_runner.public_ip
}
