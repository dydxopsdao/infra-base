resource "aws_iam_user" "user" {
  name = var.name
}

data "aws_iam_policy_document" "policy" {
  statement {
    effect    = "Allow"
    actions   = var.permissions
    resources = ["*"]
  }
}

resource "aws_iam_user_policy" "policy" {
  name   = "${var.name}-permissions"
  user   = aws_iam_user.user.name
  policy = data.aws_iam_policy_document.policy.json
}

resource "aws_iam_access_key" "key" {
  user = aws_iam_user.user.name
}