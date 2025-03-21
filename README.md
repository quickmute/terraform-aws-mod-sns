# SNS Module
Generic SNS Module

## Features
- Automatic creation of logging role
- Automatic append account number and region to name
- Automatic enforcement of encryption
- Ability to toggle org and account level permission
- Ability to enable publish from s3, event, and cloudwatch alarm

## ChangeLogs
### 1.1.0
- Output

### 1.0.0 
- Initial

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.delivery_status_logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.delivery_status_logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_sns_topic.sns_topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_policy.sns_topic_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_policy) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.delivery_logging_trust_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.delivery_status_logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.sns_topic_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_organizations_organization.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organization) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_ids"></a> [account\_ids](#input\_account\_ids) | (Optional) The AWS Account IDs which can Publish to this SNS Topic. org\_access var will override this. | `list(string)` | `[]` | no |
| <a name="input_enforce_transit_encryption"></a> [enforce\_transit\_encryption](#input\_enforce\_transit\_encryption) | (Optional) To enforce encryption in transit. | `bool` | `true` | no |
| <a name="input_include_failed_delivery_logging"></a> [include\_failed\_delivery\_logging](#input\_include\_failed\_delivery\_logging) | (Optional) Should failed message delivery be logged to CloudWatch? Defaults to false | `bool` | `false` | no |
| <a name="input_kms_master_key_id"></a> [kms\_master\_key\_id](#input\_kms\_master\_key\_id) | (Optional) The ID of an AWS-managed customer master key (CMK) for Amazon SNS or a custom CMK | `string` | `"alias/aws/sns"` | no |
| <a name="input_org_access"></a> [org\_access](#input\_org\_access) | (Optional) Set this to true if you want to allow any account in the org to interact with this topic. | `bool` | `false` | no |
| <a name="input_publish_from_cloudwatch"></a> [publish\_from\_cloudwatch](#input\_publish\_from\_cloudwatch) | (Optional) Set this to true if this topic receives from Cloudwatch Alarms. Pass in account\_ids to limit to specific accounts only. | `bool` | `false` | no |
| <a name="input_publish_from_events"></a> [publish\_from\_events](#input\_publish\_from\_events) | (Optional) Set this to true if this topic needs to receive from events. Cannot limit to specific event or account. Be aware! | `bool` | `false` | no |
| <a name="input_self_access"></a> [self\_access](#input\_self\_access) | (Optional) Set this to false if you want to deny this account from having direct access to this topic. | `bool` | `true` | no |
| <a name="input_sns_display_name"></a> [sns\_display\_name](#input\_sns\_display\_name) | (Optional) The display name of the topic. This is what shows when you receive email from this topic. Cannot be longer than 100 characters or contain dots. | `string` | `""` | no |
| <a name="input_sns_publish_bucket_arns"></a> [sns\_publish\_bucket\_arns](#input\_sns\_publish\_bucket\_arns) | (Optional) ARN of the S3 bucket allowed to publish to the SNS topic via S3 Bucket Notifications. This will enable bucket access. | `list(string)` | `null` | no |
| <a name="input_sns_topic_name"></a> [sns\_topic\_name](#input\_sns\_topic\_name) | (Required) The name (prefix) for the SNS topic (the actual topic name will be generated to include region). You can override this. | `string` | n/a | yes |
| <a name="input_sns_topic_name_override"></a> [sns\_topic\_name\_override](#input\_sns\_topic\_name\_override) | (Optional) Set this to true if you DO NOT want this module to append anything to the passed in sns\_topic\_name | `bool` | `false` | no |
| <a name="input_sns_topic_policy"></a> [sns\_topic\_policy](#input\_sns\_topic\_policy) | (Optional) The fully-formed AWS policy as JSON. Will default to this if provided. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Mandatory) Tags that should be applied to every resource created by this module. | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_sns_topic_arn"></a> [sns\_topic\_arn](#output\_sns\_topic\_arn) | The ARN of the topic |
| <a name="output_sns_topic_name"></a> [sns\_topic\_name](#output\_sns\_topic\_name) | The name of the topic |
