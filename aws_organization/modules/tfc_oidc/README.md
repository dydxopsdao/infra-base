# Terraform Cloud OIDC Integration with AWS

This module sets up the necessary AWS resources to integrate Terraform Cloud with AWS using OpenID Connect (OIDC). 
It creates the necessary OIDC provider and an IAM assume role in a member AWS account.

https://developer.hashicorp.com/terraform/cloud-docs/workspaces/dynamic-provider-credentials

## Usage

### Member AWS Account
```
module "tfc_oidc_member-workspace {
  source = "./modules/tfc_oidc"
  providers = {
    aws = aws.member_account
  }

  tfc_workspace_name    = "member-workspace"
  tfc_role_permissions  = ["ec2:*", "s3:*"] 
  # Apply least-privilege principle when declaring role permissions
}

output "module_outputs" {
  value     = module.tfc_oidc_member
}
```
### Steps to configure Terraform Cloud

1. Create a new workspace in Terraform Cloud for each AWS account you want to manage.
2. In each workspace, go to the "Variables" tab and add the following **environment** variables:
* TFC_AWS_PROVIDER_AUTH: Set to true
* TFC_AWS_RUN_ROLE_ARN: Set to the ARN of the IAM role created by the module (use the tfc_aws_run_role_arn output)

In your Terraform configuration for each workspace, make sure to use the AWS provider without any static credentials:
