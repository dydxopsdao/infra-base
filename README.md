# infra-base
Infrastructure base for the organization.

## aws-accounts

The `terraform/aws-accounts` directory describes metadata about the organization's member accounts.

In each account there is usually the `terraformer` IAM user, meant as a starting point for another
Terraform configuration, defined in another repository. There may be more resources liker that but
the idea is to keep it just as a bootstrap.
