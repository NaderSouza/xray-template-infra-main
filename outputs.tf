output "xray_ecs_policy_arn" {
  description = "ARN da IAM policy para ECS tasks enviarem traces X-Ray"
  value       = aws_iam_policy.xray_ecs_policy.arn
}

output "xray_ecs_role_arn" {
  description = "ARN da IAM role para ECS tasks com permissoes X-Ray"
  value       = aws_iam_role.xray_ecs_role.arn
}

output "s3_alb_access_logs_bucket" {
  description = "S3 bucket para ALB access logs"
  value       = aws_s3_bucket.alb_access_logs.id
}

output "xray_sampling_rule_prod_arn" {
  description = "ARN da sampling rule de producao"
  value       = aws_xray_sampling_rule.frontconsig_prod.arn
}

output "xray_sampling_rule_non_prod_arn" {
  description = "ARN da sampling rule non-prod"
  value       = aws_xray_sampling_rule.frontconsig_non_prod.arn
}

output "xray_group_frontconsig_arn" {
  description = "ARN do X-Ray group FrontConsig"
  value       = aws_xray_group.frontconsig.arn
}

output "cloudwatch_dashboard_name" {
  description = "Nome do CloudWatch dashboard"
  value       = aws_cloudwatch_dashboard.xray.dashboard_name
}
