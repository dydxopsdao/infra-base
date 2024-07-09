# Generate the IAM policy document for the SCP
data "aws_iam_policy_document" "scp_policy_document" {
  dynamic "statement" {
    for_each = var.policy_statements
    content {
      effect      = statement.value.effect
      actions     = lookup(statement.value, "actions", null)
      not_actions = lookup(statement.value, "not_actions", null)
      resources   = statement.value.resources

      # Add conditions to the policy statement if specified
      dynamic "condition" {
        for_each = lookup(statement.value, "conditions", [])
        content {
          test     = condition.value.test
          variable = condition.value.variable
          values   = condition.value.values
        }
      }
    }
  }
}

# Create the SCP in AWS Organization
resource "aws_organizations_policy" "scp" {
  name        = var.policy_name
  description = var.policy_description
  content     = data.aws_iam_policy_document.scp_policy_document.json
}

# Attach the SCP to specified targets (OUs or accounts)
resource "aws_organizations_policy_attachment" "attachment" {
  for_each  = toset(var.target_ids)
  policy_id = aws_organizations_policy.scp.id
  target_id = each.key
}