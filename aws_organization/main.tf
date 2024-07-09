module "password_policy_dos_organization" {
  source = "./modules/password_policy"
  providers = {
    aws = aws.org_level
  }
}

data "aws_organizations_organization" "org" {}

module "prevent_leave_org_scp" {
  source = "./modules/aws_organization_scp"
  providers = {
    aws = aws.org_level
  }
  policy_name        = "PreventLeaveOrganization"
  policy_description = "Prevents accounts from leaving the organization"
  policy_statements = [
    {
      effect     = "Deny"
      actions    = ["organizations:LeaveOrganization"]
      resources  = ["*"]
      conditions = []
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
  policy_description = "Restricts usage to approved regions"
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

module "prevent_disable_ebs_encryption_scp" {
  source = "./modules/aws_organization_scp"
  providers = {
    aws = aws.org_level
  }
  policy_name        = "PreventDisableEBSEncryption"
  policy_description = "Prevents disabling default EBS encryption"
  policy_statements = [
    {
      effect     = "Deny"
      actions    = ["ec2:DisableEbsEncryptionByDefault"]
      resources  = ["*"]
      conditions = []
    }
  ]
  target_ids = [data.aws_organizations_organization.org.roots[0].id]
}

module "deny_unencrypted_ebs_volumes_scp" {
  source = "./modules/aws_organization_scp"
  providers = {
    aws = aws.org_level
  }
  policy_name        = "DenyUnencryptedEBSVolumes"
  policy_description = "Denies creation of unencrypted EBS volumes"
  policy_statements = [
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

# Enable default EBS encryption for ap-northeast-1
resource "aws_ebs_encryption_by_default" "ap_northeast_1" {
  provider = aws.org_level
  enabled  = true
}

# Other AWS organization-related resources and modules can be added here