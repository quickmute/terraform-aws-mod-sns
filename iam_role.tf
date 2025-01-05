resource "aws_iam_role" "delivery_status_logging" {
  count              = var.include_failed_delivery_logging ? 1 : 0
  name               = "${local.topic_name}_logging"
  tags               = merge(var.tags, { Name = "${local.topic_name}_logging" })
  assume_role_policy = data.aws_iam_policy_document.delivery_logging_trust_policy.json
}

data "aws_iam_policy_document" "delivery_logging_trust_policy" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type        = "Service"
      identifiers = ["sns.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "delivery_status_logging" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:PutMetricFilter",
      "logs:PutRetentionPolicy"
    ]
    resources = [
      "*"
    ]
  }
}

resource "aws_iam_role_policy" "delivery_status_logging" {
  count = var.include_failed_delivery_logging ? 1 : 0

  name = "${local.topic_name}_logging"
  role = aws_iam_role.delivery_status_logging[0].name

  policy = data.aws_iam_policy_document.delivery_status_logging.json
}
