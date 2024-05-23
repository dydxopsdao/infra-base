# Use the global AWS provider for managing SCP policies in the AWS organization
provider "aws" {
  region = "ap-northeast-1"
}



# SCP policy to restrict AWS services to approved region/s
module "scp_policy" {
  source             = "./modules/scp_policy"
  providers = {
    aws = aws  // Use the global AWS provider configuration
  }
  policy_name        = "RestrictRegionsPolicy"
  policy_description = "Restrict AWS services to approved regions only"
  approved_regions   = [
    "ap-southeast-1",
    "ap-northeast-1",
    "eu-central-1",
    "eu-west-1"
    // Add your approved regions here
  ]    
  target_ou_id        = "r-9w63"  // root OU ID
}


# SCP policy to prevent member account from leaving the organization
module "prevent_leaving_org_scp" {
  source          = "./modules/organization_scp"
  providers = {
    aws = aws  // Use the global AWS provider configuration
  }
  scp_name        = "PreventLeavingOrganization"
  scp_description = "This SCP prevents member accounts from leaving the organization."
  target_ids      = ["r-9w63"]  // root OU ID
}
