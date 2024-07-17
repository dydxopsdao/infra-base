# Fetch TLS certificate for Terraform Cloud
data "tls_certificate" "tfc_certificate" {
  url   = "https://${var.tfc_hostname}"
}

# Create OIDC provider if specified
resource "aws_iam_openid_connect_provider" "tfc_provider" {
  url             = data.tls_certificate.tfc_certificate.url
  client_id_list  = [var.tfc_aws_audience]
  thumbprint_list = [data.tls_certificate.tfc_certificate.certificates[0].sha1_fingerprint]
}

# Define IAM assume role within member accountwith a trust relationship 
# so that only specified Terraform Cloud workspace can assume this role
data "aws_iam_policy_document" "tfc_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.tfc_provider.arn]
    }
    
    condition {
      test     = "StringEquals"
      variable = "${var.tfc_hostname}:aud"
      values   = [var.tfc_aws_audience]
    }
    
    condition {
      test     = "StringLike"
      variable = "${var.tfc_hostname}:sub"
      values   = ["organization:${var.tfc_organization_name}:project:${var.tfc_project_name}:workspace:${var.tfc_workspace_name}:run_phase:*"]
    }
  }
}

# Create IAM role for Terraform Cloud
resource "aws_iam_role" "tfc_role" {
  name               = var.tfc_role_name
  assume_role_policy = data.aws_iam_policy_document.tfc_assume_role_policy.json
}

# Define IAM policy for Terraform Cloud role
data "aws_iam_policy_document" "tfc_policy" {
  statement {
    effect    = "Allow"
    actions   = var.tfc_role_permissions
    resources = ["*"]
  }
}

# Create IAM policy
resource "aws_iam_policy" "tfc_policy" {
  name        = var.tfc_policy_name
  description = "TFC run policy permissions"
  policy      = data.aws_iam_policy_document.tfc_policy.json
}

# Attach policy to role
resource "aws_iam_role_policy_attachment" "tfc_policy_attachment" {
  role       = aws_iam_role.tfc_role.name
  policy_arn = aws_iam_policy.tfc_policy.arn
}