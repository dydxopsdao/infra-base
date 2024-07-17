output "tfc_aws_run_role_arn" {
  description = "ARN of the IAM role for Terraform Cloud to assume"
  value       = aws_iam_role.tfc_role.arn
}