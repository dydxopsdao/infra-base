module "password_policy_dos_organization" {
  source = "./modules/password_policy"
  providers = {
    aws = aws.org_level
  }
}

# Enable default EBS encryption for ap-northeast-1
resource "aws_ebs_encryption_by_default" "ap_northeast_1" {
  provider = aws.org_level
  enabled  = true
}

data "aws_organizations_organization" "org" {}

module "ebs_encryption_policy" {
  source = "./modules/aws_organization_scp"
  providers = {
    aws = aws.org_level
  }
  policy_name        = "EnforceEBSEncryption"
  policy_description = "Prevents disabling default EBS encryption and denies the creation of unencrypted EBS volumes."
  
  policy_statements = [
    {
      effect     = "Deny"
      actions    = ["ec2:DisableEbsEncryptionByDefault"]
      resources  = ["*"]
      conditions = []
    },
    {
      effect    = "Deny"
      actions   = ["ec2:CreateVolume"]
      resources = ["*"]
      conditions = [
        {
          test     = "Bool"
          variable = "ec2:Encrypted"
          values   = ["false"]
        }
      ]
    }
  ]

  target_ids = [data.aws_organizations_organization.org.roots[0].id]
}

module "security_controls_policy" {
  source = "./modules/aws_organization_scp"
  providers = {
    aws = aws.org_level
  }
  policy_name        = "SecurityControls"
  policy_description = "Combines security controls to prevent root user actions, prevent leaving the organization, and control IAM Identity center instance creation."

  policy_statements = [
    {
      effect     = "Deny"
      actions    = ["organizations:LeaveOrganization"]
      resources  = ["*"]
      conditions = []
    },
    {
      effect    = "Deny"
      actions   = ["*"]
      resources  = ["*"]
      conditions = [
        {
          test     = "StringLike"
          variable = "aws:PrincipalArn"
          values   = ["arn:aws:iam::*:root"]
        }
      ]
    },
    {
      effect    = "Deny"
      actions   = ["sso:CreateInstance"]
      resources = ["*"]
      conditions = [
        {
          test     = "StringNotEquals"
          variable = "aws:PrincipalAccount"
          values   = [data.aws_organizations_organization.org.master_account_id]
        }
      ]
    }
  ]

  target_ids = [data.aws_organizations_organization.org.roots[0].id]
}

module "region_restriction_scp" {
  source = "./modules/aws_organization_scp"
  providers = {
    aws = aws.org_level
  }
  policy_name        = "RegionRestriction"
  policy_description = "Restricts usage to approved regions."
  
  policy_statements = [
    {
      effect      = "Deny"
      not_actions = var.allowed_global_actions
      resources   = ["*"]
      conditions = [
        {
          test     = "StringNotEquals"
          variable = "aws:RequestedRegion"
          values   = var.approved_regions
        }
      ]
    }
  ]

  target_ids = [data.aws_organizations_organization.org.roots[0].id]
}

# Other AWS organization-related resources and modules can be added here