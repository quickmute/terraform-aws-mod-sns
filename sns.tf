//////////////////////////////////////////////////////////////
// SNS Topics ///////////////////////////////////////////
// https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-use-resource-based.html#eb-sns-permissions
//////////////////////////////////////////////////////////////

resource "aws_sns_topic" "sns_topic" {
  name                          = local.topic_name
  display_name                  = var.sns_display_name
  tags                          = merge(var.tags, { Name = local.topic_name })
  sqs_failure_feedback_role_arn = var.include_failed_delivery_logging ? aws_iam_role.delivery_status_logging[0].arn : null
  kms_master_key_id             = var.kms_master_key_id
}

resource "aws_sns_topic_policy" "sns_topic_policy" {
  arn    = aws_sns_topic.sns_topic.arn
  policy = var.sns_topic_policy == null ? data.aws_iam_policy_document.sns_topic_policy.json : var.sns_topic_policy
}

data "aws_iam_policy_document" "sns_topic_policy" {
  policy_id = "SNS_topic_policy"
  ## Self Access
  dynamic "statement" {
    for_each = var.self_access ? [1] : []
    content {
      sid    = "allowfromself"
      effect = "Allow"
      actions = [
        "SNS:Subscribe",
        "SNS:SetTopicAttributes",
        "SNS:RemovePermission",
        "SNS:Receive",
        "SNS:Publish",
        "SNS:ListSubscriptionsByTopic",
        "SNS:GetTopicAttributes",
        "SNS:DeleteTopic",
        "SNS:AddPermission",
      ]
      resources = [
        aws_sns_topic.sns_topic.arn
      ]
      principals {
        type        = "AWS"
        identifiers = ["*"]
      }
      condition {
        test     = "StringEquals"
        variable = "AWS:SourceOwner"
        values = [
          data.aws_caller_identity.current.account_id,
        ]
      }
    }
  }
  ## Specific Account Access
  dynamic "statement" {
    for_each = length(var.account_ids) > 0 && var.org_access == false ? [1] : []
    content {
      sid    = "allowfromtheseaccountroots"
      effect = "Allow"
      actions = [
        "SNS:Publish",
        "SNS:Subscribe",
        "SNS:ListSubscriptionsByTopic",
        "SNS:GetTopicAttributes",
      ]
      resources = [
        aws_sns_topic.sns_topic.arn,
      ]
      principals {
        type        = "AWS"
        identifiers = formatlist("arn:aws:iam::%s:root", var.account_ids)
      }
    }
  }
  ## Org Access
  dynamic "statement" {
    for_each = var.org_access ? [1] : []
    content {
      sid    = "allowfromorg"
      effect = "Allow"
      actions = [
        "SNS:Publish",
        "SNS:Subscribe",
        "SNS:ListSubscriptionsByTopic",
        "SNS:GetTopicAttributes",
      ]
      resources = [
        aws_sns_topic.sns_topic.arn,
      ]
      principals {
        type        = "AWS"
        identifiers = ["*"]
      }
      condition {
        test     = "StringEquals"
        variable = "aws:PrincipalOrgID"
        values = [
          local.org_id
        ]
      }
    }
  }
  ## Event Access
  ## You can't use of Condition blocks in Amazon SNS topic policies for EventBridge.
  dynamic "statement" {
    for_each = var.publish_from_events ? [1] : []
    content {
      sid    = "allowfromevents"
      effect = "Allow"
      actions = [
        "SNS:Publish"
      ]
      resources = [
        aws_sns_topic.sns_topic.arn
      ]
      principals {
        type = "Service"
        identifiers = [
          "events.amazonaws.com"
        ]
      }
    }
  }
  ## Bucket Access
  dynamic "statement" {
    for_each = var.sns_publish_bucket_arns != null ? [1] : []
    content {
      sid    = "allowfromspecificbucket"
      effect = "Allow"
      actions = [
        "SNS:Publish"
      ]
      resources = [
        aws_sns_topic.sns_topic.arn
      ]
      principals {
        type        = "Service"
        identifiers = ["s3.amazonaws.com"]
      }
      condition {
        test     = "ArnLike"
        variable = "AWS:SourceArn"
        values   = var.sns_publish_bucket_arns
      }
      condition {
        test     = "StringEquals"
        variable = "AWS:SourceAccount"
        values = [
          data.aws_caller_identity.current.account_id,
        ]
      }
    }
  }
  ## CloudWatch Alarm Access
  ## You must pass in a length(var.account_ids) > 0 in order to pass in specific account conditioning
  dynamic "statement" {
    for_each = var.publish_from_cloudwatch ? [1] : []
    content {
      sid    = "allowfromcloudwatch"
      effect = "Allow"
      actions = [
        "SNS:Publish"
      ]
      resources = [
        aws_sns_topic.sns_topic.arn
      ]
      principals {
        type = "Service"
        identifiers = [
          "cloudwatch.amazonaws.com"
        ]
      }
      dynamic "condition" {
        for_each = length(var.account_ids) > 0 ? [1] : []
        content {
          test     = "ArnLike"
          variable = "aws:SourceArn"
          values   = formatlist("arn:aws:cloudwatch:*:%s:*", var.account_ids)
        }
      }
    }
  }

  ## Enforce encryption of data in transit
  dynamic "statement" {
    for_each = var.enforce_transit_encryption ? [1] : []
    content {
      sid    = "AllowPublishThroughSSLOnly"
      effect = "Deny"
      actions = [
        "SNS:Publish"
      ]
      resources = [
        aws_sns_topic.sns_topic.arn
      ]
      principals {
        type        = "AWS"
        identifiers = ["*"]
      }
      condition {
        test     = "Bool"
        variable = "aws:SecureTransport"
        values   = ["false"]
      }
    }
  }
}