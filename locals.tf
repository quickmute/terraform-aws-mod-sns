## actual used topic name includes the current region
locals {
  topic_name = var.sns_topic_name_override == true ? var.sns_topic_name : join("-", [var.sns_topic_name, data.aws_region.current.name])
  org_id     = data.aws_organizations_organization.current.id
}
