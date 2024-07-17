resource "aws_organizations_account" "dos_metric_ingestor_testnet" {
  provider  = aws.org_level
  name      = "dos-metric-ingestor-testnet"
  email     = "infrastructure+metric-ingestor-testnet-2@dydxopsservices.com" # The "-2" suffix is due to an old account being deleted
  role_name = "OrganizationAccountAccessRole"

  # There is no AWS Organizations API for reading role_name
  lifecycle {
    ignore_changes = [role_name]
  }
}

# Account-level provider, used to manage resources in the member account
provider "aws" {
  alias  = "dos_metric_ingestor_testnet"
  region = "ap-northeast-1"
  assume_role {
    role_arn = "arn:aws:iam::${aws_organizations_account.dos_metric_ingestor_testnet.id}:role/OrganizationAccountAccessRole"
  }
}

module "dos_metric_ingestor_testnet_terraformer" {
  source = "./modules/iam_user"
  providers = {
    aws = aws.dos_metric_ingestor_testnet
  }
  name = "terraformer"
  permissions = [
    # IAM full access
    "iam:*",

    # EC2 full access
    "ec2:*",
    "ecs:*",
    "elasticloadbalancing:*",
    "cloudwatch:*",
    "autoscaling:*",
    "application-autoscaling:*",
    "codedeploy:*",
    "appmesh:DescribeVirtualGateway",
    "appmesh:DescribeVirtualNode",
    "appmesh:ListMeshes",
    "appmesh:ListVirtualGateways",
    "appmesh:ListVirtualNodes",
    "cloudformation:CreateStack",
    "cloudformation:DeleteStack",
    "cloudformation:DescribeStack*",
    "cloudformation:UpdateStack",
    "cloudwatch:DeleteAlarms",
    "cloudwatch:DescribeAlarms",
    "cloudwatch:GetMetricStatistics",
    "cloudwatch:PutMetricAlarm",
    "elasticfilesystem:DescribeAccessPoints",
    "elasticfilesystem:DescribeFileSystems",
    "events:DeleteRule",
    "events:DescribeRule",
    "events:ListRuleNamesByTarget",
    "events:ListTargetsByRule",
    "events:PutRule",
    "events:PutTargets",
    "events:RemoveTargets",
    "fsx:DescribeFileSystems",
    "lambda:ListFunctions",
    "logs:CreateLogGroup",
    "logs:DescribeLogGroups",
    "logs:FilterLogEvents",
    "route53:CreateHostedZone",
    "route53:DeleteHostedZone",
    "route53:GetHealthCheck",
    "route53:GetHostedZone",
    "route53:ListHostedZonesByName",
    "servicediscovery:CreatePrivateDnsNamespace",
    "servicediscovery:CreateService",
    "servicediscovery:DeleteService",
    "servicediscovery:GetNamespace",
    "servicediscovery:GetOperation",
    "servicediscovery:GetService",
    "servicediscovery:ListNamespaces",
    "servicediscovery:ListServices",
    "servicediscovery:UpdateService",
    "sns:ListTopics",
  ]
}

output "dos_metric_ingestor_testnet_aws_account_id" {
  value     = aws_organizations_account.dos_metric_ingestor_testnet.id
}

output "dos_metric_ingestor_testnet_terraformer_outputs" {
  value     = module.dos_metric_ingestor_testnet_terraformer
  sensitive = true
}

# Integrate Terraform Cloud workspace with AWS using OpenID Connect (OIDC)
module "tfc_oidc_dos_metric_ingestor_testnet" {
  source = "./modules/tfc_oidc"
  providers = {
    aws = aws.dos_metric_ingestor_testnet
  }

  tfc_workspace_name    = "v4-metric-ingestor-testnet"
  tfc_policy_name       = "tfc_metric_ingestor_testnet_policy"
  tfc_role_permissions = [
    # IAM full access
    "iam:*",

    # EC2 full access
    "ec2:*",
    "ecs:*",
    "elasticloadbalancing:*",
    "cloudwatch:*",
    "autoscaling:*",
    "application-autoscaling:*",
    "codedeploy:*",
    "appmesh:DescribeVirtualGateway",
    "appmesh:DescribeVirtualNode",
    "appmesh:ListMeshes",
    "appmesh:ListVirtualGateways",
    "appmesh:ListVirtualNodes",
    "cloudformation:CreateStack",
    "cloudformation:DeleteStack",
    "cloudformation:DescribeStack*",
    "cloudformation:UpdateStack",
    "cloudwatch:DeleteAlarms",
    "cloudwatch:DescribeAlarms",
    "cloudwatch:GetMetricStatistics",
    "cloudwatch:PutMetricAlarm",
    "elasticfilesystem:DescribeAccessPoints",
    "elasticfilesystem:DescribeFileSystems",
    "events:DeleteRule",
    "events:DescribeRule",
    "events:ListRuleNamesByTarget",
    "events:ListTargetsByRule",
    "events:PutRule",
    "events:PutTargets",
    "events:RemoveTargets",
    "fsx:DescribeFileSystems",
    "lambda:ListFunctions",
    "logs:CreateLogGroup",
    "logs:DescribeLogGroups",
    "logs:FilterLogEvents",
    "route53:CreateHostedZone",
    "route53:DeleteHostedZone",
    "route53:GetHealthCheck",
    "route53:GetHostedZone",
    "route53:ListHostedZonesByName",
    "servicediscovery:CreatePrivateDnsNamespace",
    "servicediscovery:CreateService",
    "servicediscovery:DeleteService",
    "servicediscovery:GetNamespace",
    "servicediscovery:GetOperation",
    "servicediscovery:GetService",
    "servicediscovery:ListNamespaces",
    "servicediscovery:ListServices",
    "servicediscovery:UpdateService",
    "sns:ListTopics",
  ]
  # Apply least-privilege principle when declaring role permissions
}

output "module_outputs_dos_metric_ingestor_testnet" {
  value     = module.tfc_oidc_dos_metric_ingestor_testnet
}