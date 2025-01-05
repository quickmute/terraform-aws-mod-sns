###############################################################
## Variables ##################################################
###############################################################

variable "sns_topic_name" {
  description = "(Required) The name (prefix) for the SNS topic (the actual topic name will be generated to include region). You can override this."
  type        = string
}

variable "sns_display_name" {
  description = "(Optional) The display name of the topic. This is what shows when you receive email from this topic. Cannot be longer than 100 characters or contain dots."
  type        = string
  default     = ""
  validation {
    condition     = length(var.sns_display_name) < 100 && length(regexall("\\.", var.sns_display_name)) == 0
    error_message = "The Display Name cannot exceed 100 characters or contain dots."
  }
}

variable "sns_topic_name_override" {
  description = "(Optional) Set this to true if you DO NOT want this module to append anything to the passed in sns_topic_name"
  type        = bool
  default     = false
}

variable "sns_topic_policy" {
  description = "(Optional) The fully-formed AWS policy as JSON. Will default to this if provided."
  default     = null
  type        = string
}

variable "sns_publish_bucket_arns" {
  description = "(Optional) ARN of the S3 bucket allowed to publish to the SNS topic via S3 Bucket Notifications. This will enable bucket access."
  type        = list(string)
  default     = null
}

variable "account_ids" {
  description = "(Optional) The AWS Account IDs which can Publish to this SNS Topic. org_access var will override this."
  type        = list(string)
  default     = []
}

variable "include_failed_delivery_logging" {
  description = "(Optional) Should failed message delivery be logged to CloudWatch? Defaults to false"
  type        = bool
  default     = false
}

variable "kms_master_key_id" {
  description = "(Optional) The ID of an AWS-managed customer master key (CMK) for Amazon SNS or a custom CMK"
  type        = string
  default     = "alias/aws/sns"
}

variable "tags" {
  type        = map(string)
  description = "(Mandatory) Tags that should be applied to every resource created by this module."
}

variable "org_access" {
  type        = bool
  default     = false
  description = "(Optional) Set this to true if you want to allow any account in the org to interact with this topic."
}

variable "self_access" {
  type        = bool
  default     = true
  description = "(Optional) Set this to false if you want to deny this account from having direct access to this topic."
}

variable "publish_from_events" {
  type        = bool
  default     = false
  description = "(Optional) Set this to true if this topic needs to receive from events. Cannot limit to specific event or account. Be aware!"
}

variable "publish_from_cloudwatch" {
  type        = bool
  default     = false
  description = "(Optional) Set this to true if this topic receives from Cloudwatch Alarms. Pass in account_ids to limit to specific accounts only."
}

variable "enforce_transit_encryption" {
  type        = bool
  default     = true
  description = "(Optional) To enforce encryption in transit."
}
