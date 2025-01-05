provider "aws" {
  region  = "us-east-1"
  profile = "default"
}

output "sns_topic" {
  value = module.sns_topic
}

module "sns_topic" {
  source = "../../"

  sns_topic_name                  = "example_sns_topic"
  sns_display_name                = "example"
  include_failed_delivery_logging = false
  publish_from_cloudwatch         = true
  publish_from_events             = true
  tags                            = { "Name" = "example_sns_topic" }
}