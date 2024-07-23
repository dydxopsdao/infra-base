resource "aws_organizations_account" "dos_amplitude_api_gateway" {
  provider  = aws.org_level
  name      = "dos-amplitude-api-gateway"
  email     = "infrastructure+amplitude-api-gateway@dydxopsservices.com"
  role_name = "OrganizationAccountAccessRole"

  # There is no AWS Organizations API for reading role_name
  lifecycle {
    ignore_changes = [role_name]
  }
}

# Account-level provider, used to manage resources in the member account
provider "aws" {
  alias  = "dos_amplitude_api_gateway"
  region = "ap-northeast-1"
  assume_role {
    role_arn = "arn:aws:iam::${aws_organizations_account.dos_amplitude_api_gateway.id}:role/OrganizationAccountAccessRole"
  }
}

# Define the IAM account password policy
module "password_policy_dos_amplitude_api_gateway" {
  source = "./modules/password_policy"
  providers = {
    aws = aws.dos_amplitude_api_gateway
  }
}

# Integrate Terraform Cloud workspace with AWS using OpenID Connect (OIDC)
module "tfc_oidc_dos_amplitude_api_gateway" {
  source = "./modules/tfc_oidc"
  providers = {
    aws = aws.dos_amplitude_api_gateway
  }

  tfc_workspace_name    = "amplitude-api-gateway"
  tfc_policy_name       = "tfc_amplitude_api_gateway_policy"
  tfc_role_permissions  = ["apigateway:*"] 
}

output "module_outputs_dos_amplitude_api_gateway" {
  value     = module.tfc_oidc_dos_amplitude_api_gateway
}