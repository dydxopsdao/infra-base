# aws_organization

## Overview

The `aws_organization` directory describes metadata about the organization's member accounts.

In each account there is usually the `terraformer` IAM user, meant as a starting point for another
Terraform configuration, defined in another repository. There may be more resources like that but
the idea is to keep it simple and as a bootstrap only.

The Terraform state is kept in S3.

## Usage

Make sure you have the AWS CLI configured and the `aws` command is available.

### Authentication methods

**Method 1**:

Create a profile in `~/.aws/credentials`, e.g.:

```
[dydxopsdao]
aws_access_key_id = your-key-id
aws_secret_access_key = your-secret
```

Then point to it with an env var:

```
export AWS_PROFILE=dydxopsdao
```

**Method 2**:

Place the key credentials in env vars:

```
 export AWS_ACCESS_KEY_ID=your-key-id
 export AWS_SECRET_ACCESS_KEY=your-secret
```

**Ready!**

Run locally:

```
cd aws_organization
terraform init
terraform plan
```
