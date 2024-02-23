resource "aws_organizations_account" "dos_metric_ingestor_mainnet" {
  provider  = aws.org_level
  name      = "dos-metric-ingestor-mainnet"
  email     = "infrastructure+metric-ingestor-mainnet@dydxopsservices.com"
  role_name = "OrganizationAccountAccessRole"

  # There is no AWS Organizations API for reading role_name
  lifecycle {
    ignore_changes = [role_name]
  }
}

# Account-level provider, used to manage resources in the member account
provider "aws" {
  alias  = "dos_metric_ingestor_mainnet"
  region = "ap-northeast-1"
  assume_role {
    role_arn = "arn:aws:iam::${aws_organizations_account.dos_metric_ingestor_mainnet.id}:role/OrganizationAccountAccessRole"
  }
}

module "dos_metric_ingestor_mainnet_terraformer" {
  source = "./modules/iam_user"
  providers = {
    aws = aws.dos_metric_ingestor_mainnet
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

output "dos_metric_ingestor_mainnet_terraformer_outputs" {
  value     = module.dos_metric_ingestor_mainnet_terraformer
  sensitive = true
}
