module "password_policy_dos_organization" {
  source = "./modules/password_policy"
  providers = {
    aws = aws.org_level
  }
}

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
  target_ids = var.prevent_leave_org_target_ids
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
  target_ids = var.region_restriction_target_ids
}

# Other AWS organization-related resources and modules can be added here