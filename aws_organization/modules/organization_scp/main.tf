data "aws_iam_policy_document" "scp_policy_document" {
  statement {
    effect    = "Deny"
    actions   = ["organizations:LeaveOrganization"]
    resources = ["*"]
  }
}

resource "aws_organizations_policy" "scp" {
  name        = var.scp_name
  description = var.scp_description
  content     = data.aws_iam_policy_document.scp_policy_document.json
}

resource "aws_organizations_policy_attachment" "attachment" {
  for_each = toset(var.target_ids)
  policy_id = aws_organizations_policy.scp.id
  target_id = each.key
}
