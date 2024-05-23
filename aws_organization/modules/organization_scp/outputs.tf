output "scp_id" {
  description = "The ID of the Service Control Policy"
  value       = aws_organizations_policy.scp.id
}