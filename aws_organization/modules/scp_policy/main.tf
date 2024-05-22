data "aws_iam_policy_document" "scp_policy_document" {
  statement {
    effect = "Deny"
    not_actions = [
      "a4b:*",
      "budgets:*",
      "ce:*",
      "chime:*",
      "cloudfront:*",
      "cur:*",
      "globalaccelerator:*",
      "health:*",
      "iam:*",
      "importexport:*",
      "mobileanalytics:*",
      "organizations:*",
      "route53:*",
      "route53domains:*",
      "shield:*",
      "support:*",
      "trustedadvisor:*",
      "waf:*",
      "wellarchitected:*"
    ]
    resources = ["*"]
    condition {
      test     = "StringNotEquals"
      variable = "aws:RequestedRegion"
      values   = var.approved_regions
    }
  }
}

resource "aws_organizations_policy" "scp_policy" {
  name        = var.policy_name
  description = var.policy_description
  content     = data.aws_iam_policy_document.scp_policy_document.json
}

resource "aws_organizations_policy_attachment" "scp_policy_attachment" {
  policy_id = aws_organizations_policy.scp_policy.id
  target_id = var.target_ou_id
}