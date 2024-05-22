output "scp_policy_id" {
  description = "The ID of the SCP policy"
  value       = aws_organizations_policy.scp_policy.id
}

output "scp_policy_attachment_id" {
  description = "The ID of the SCP policy attachment"
  value       = aws_organizations_policy_attachment.scp_policy_attachment.id
}
