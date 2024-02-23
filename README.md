# infra-base
Infrastructure base for the organization.

## Overview

The `aws_organization` directory describes metadata about the organization's member accounts.

In each account there is usually the `terraformer` IAM user, meant as a starting point for another
Terraform configuration, defined in another repository. There may be more resources liker that but
the idea is to keep it just as a bootstrap.

Terraform Cloud is used to keep the state, however, for additional security, no user credentials 
are stored in the Terraform Cloud workspace (as is the case for member account-level projects).
Instead, each user is required to provide their own AWS credentials in a local file.

## Usage

Create the `aws_organization/.aws-credentials` file with the following contents:

```
[default]
aws_access_key_id = your-key-id
aws_secret_access_key = your-secret
```

Then run:

```
terraform init
terraform plan
```
