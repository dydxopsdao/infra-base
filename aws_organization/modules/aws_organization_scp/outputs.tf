# Output the ID of the created SCP
output "scp_id" {
  description = "The ID of the Service Control Policy"
  value       = aws_organizations_policy.scp.id
}

# Output a map of target IDs to their corresponding SCP attachment IDs
output "scp_attachment_ids" {
  description = "Map of target IDs to their SCP attachment IDs"
  value       = { for k, v in aws_organizations_policy_attachment.attachment : k => v.id }
}