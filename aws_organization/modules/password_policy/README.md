# AWS IAM Account Password Policy Terraform Module

This Terraform module sets up an IAM Account Password Policy for an AWS account.

## Inputs

To use this module, create a Terraform configuration file (e.g., `main.tf`) in your project and include the following:
| Variable                          | Description                                      | Type    | Default    |
|-----------------------------------|--------------------------------------------------|---------|------------|
| `region`                          | The AWS region to create resources in            | string  | `"us-west-2"` |
| `minimum_password_length`         | Minimum length of the password                   | number  | `8`        |
| `require_lowercase_characters`    | Require lowercase characters in the password     | bool    | `true`     |
| `require_numbers`                 | Require numbers in the password                  | bool    | `true`     |
| `require_uppercase_characters`    | Require uppercase characters in the password     | bool    | `true`     |
| `require_symbols`                 | Require symbols in the password                  | bool    | `true`     |
| `allow_users_to_change_password`  | Allow users to change their password             | bool    | `true`     |
| `max_password_age`                | The maximum age of the password in days          | number  | `180`      |
| `password_reuse_prevention`       | The number of previous passwords that cannot be reused | number  | `6`       |


## Usage
If you want to accept the default values, don't specify any input variables. Terraform will automatically use the default values defined in the module.

```hcl
module "iam_password_policy" {
  source = "./modules/password_policy"

  # Optionally override default values
  region                      = "ap-northeast-1"
  minimum_password_length     = 8
  require_lowercase_characters = true
  require_numbers             = true
  require_uppercase_characters = true
  require_symbols             = true
  allow_users_to_change_password = true
  max_password_age            = 180
  password_reuse_prevention   = 6
}