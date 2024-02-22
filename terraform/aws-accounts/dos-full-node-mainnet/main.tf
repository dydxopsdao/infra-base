resource "aws_organizations_account" "account" {
  provider  = aws.org_level
  name      = "dos-full-node-mainnet"
  email     = "infrastructure+full-node-mainnet@dydxopsservices.com"
  role_name = "OrganizationAccountAccessRole"

  # There is no AWS Organizations API for reading role_name
  lifecycle {
    ignore_changes = [role_name]
  }
}

module "iam_user_terraformer" {
  source      = "../../modules/iam_user"
  providers   = { aws = aws.account_level }
  name        = "terraformer"
  permissions = ["ec2:*"]
}
