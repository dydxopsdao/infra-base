resource "aws_organizations_account" "dos_rpc_monitor_mainnet" {
  provider  = aws.org_level
  name      = "dos-rpc-monitor-mainnet"
  email     = "infrastructure+rpc-monitor-mainnet@dydxopsservices.com"
  role_name = "OrganizationAccountAccessRole"

  # There is no AWS Organizations API for reading role_name
  lifecycle {
    ignore_changes = [role_name]
  }
}

# Account-level provider, used to manage resources in the member account
provider "aws" {
  alias  = "dos_rpc_monitor_mainnet"
  region = "ap-northeast-1"
  assume_role {
    role_arn = "arn:aws:iam::${aws_organizations_account.dos_rpc_monitor_mainnet.id}:role/OrganizationAccountAccessRole"
  }
}

# Define the IAM account password policy
module "password_policy_dos_rpc_monitor_mainnet" {
  source = "./modules/password_policy"
  providers = {
    aws = aws.dos_rpc_monitor_mainnet
  }
}

# Integrate Terraform Cloud workspace with AWS using OpenID Connect (OIDC)
module "tfc_oidc_dos_rpc_monitor_mainnet" {
  source = "./modules/tfc_oidc"
  providers = {
    aws = aws.dos_rpc_monitor_mainnet
  }

  tfc_workspace_name    = "rpc-monitor-mainnet"
  tfc_policy_name       = "tfc_rpc_monitor_mainnet_policy"
  tfc_role_permissions = [
    # IAM full access
    "iam:*",

    # Other services full access
    "ec2:*",
    "ecs:*",
    "elasticloadbalancing:*",
    "cloudwatch:*",
    "autoscaling:*",
    "application-autoscaling:*",
    "codedeploy:*",
    "appmesh:*",
    "cloudformation:*",
    "elasticfilesystem:*",
    "events:*",
    "fsx:*",
    "lambda:*",
    "logs:*",
    "route53:*",
    "servicediscovery:*",
    "sns:*",
  ]
}

output "module_outputs_dos_rpc_monitor_mainnet" {
  value     = module.tfc_oidc_dos_rpc_monitor_mainnet
}
