resource "aws_iam_user" "this" {
  name = var.name
}

data "aws_iam_policy_document" "this" {
  statement {
    effect    = "Allow"
    actions   = var.permissions
    resources = ["*"]
  }
}

resource "aws_iam_user_policy" "policy" {
  name   = "${var.name}-permissions"
  user   = aws_iam_user.this.name
  policy = data.aws_iam_policy_document.this.json
}

resource "aws_iam_access_key" "this" {
  user = aws_iam_user.this.name
}
