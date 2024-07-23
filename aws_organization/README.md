# aws_organization

## Overview

The `aws_organization` directory describes metadata about the organization's member accounts.

In each member account, there is an Open ID Connect (OIDC) configuration to integrate Terraform Cloud (TFC) workspace with AWS. Resources in the member accounts are provisioned by TFC using OIDC provider. Terraform state of those resources is managed by TFC.

The Terraform state of the `aws_organization` is kept in S3.

## Usage

Make sure you have the AWS and Terraform CLI configured and the `aws` and `terraform` commands are available. 

### Authentication method

**AWS IAM Identity Center credentials (Recommended)**:

1\. Configure the AWS CLI to use AWS IAM Identity Center authentication

In your terminal, step through the sso configuration wizard.
If you get stuck, refer to [aws docs](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-sso.html#cli-configure-sso-configure)

```
aws configure sso
```

2\. Set the below env variable in your terminal to be used as default a profile.
You can override this setting by using the --profile parameter.
```
export AWS_PROFILE=your-organization
```

**Ready!**

Run locally:

```
cd aws_organization
aws sso login
terraform init
terraform plan
```