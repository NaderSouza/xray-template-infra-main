variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "account_id" {
  description = "AWS Account ID"
  type        = string
  default     = "528547794217"
}

variable "elb_account_id" {
  description = "AWS ELB service account ID for us-east-1 (used for S3 bucket policy)"
  type        = string
  default     = "127311923021"
}

variable "alb_log_retention_days" {
  description = "Days before ALB access logs are deleted"
  type        = number
  default     = 90
}

variable "alb_log_ia_transition_days" {
  description = "Days before ALB access logs transition to Infrequent Access"
  type        = number
  default     = 30
}
