output "access_key_id" {
  value = aws_iam_access_key.this.id
}

output "access_key_secret" {
  value     = aws_iam_access_key.this.secret
  sensitive = true
}
