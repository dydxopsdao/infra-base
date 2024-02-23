# infra-base
Infrastructure base for the organization.

## Overview

The `aws_organization` directory describes metadata about the organization's member accounts.

In each account there is usually the `terraformer` IAM user, meant as a starting point for another
Terraform configuration, defined in another repository. There may be more resources liker that but
the idea is to keep it just as a bootstrap.

The state is kept locally. TODO: Move to S3.

## Usage

Make sure you have the AWS CLI configured and the `aws` command is available.

Edit the `~/.aws/credentials` and create an entry for the `dydxopsdao` profile:

```
...

[dydxopsdao]
aws_access_key_id = your-key-id
aws_secret_access_key = your-secret

...
```

AWS providers in the configuration are set to use the `dydxopsdao` profile and this is how you will be authenticated.

Then run:

```
terraform init
terraform plan
```
