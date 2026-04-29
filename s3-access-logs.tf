###############################################################################
# S3 Bucket for centralized ALB Access Logs
###############################################################################

resource "aws_s3_bucket" "alb_access_logs" {
  bucket = "akrk-alb-access-logs-${var.account_id}"

  tags = {
    Purpose = "Centralized ALB access logs"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "alb_access_logs" {
  bucket = aws_s3_bucket.alb_access_logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "alb_access_logs" {
  bucket = aws_s3_bucket.alb_access_logs.id

  rule {
    id     = "alb-logs-lifecycle"
    status = "Enabled"

    transition {
      days          = var.alb_log_ia_transition_days
      storage_class = "STANDARD_IA"
    }

    expiration {
      days = var.alb_log_retention_days
    }
  }
}

resource "aws_s3_bucket_public_access_block" "alb_access_logs" {
  bucket = aws_s3_bucket.alb_access_logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "alb_access_logs" {
  bucket = aws_s3_bucket.alb_access_logs.id

  versioning_configuration {
    status = "Disabled"
  }
}

data "aws_iam_policy_document" "alb_access_logs_bucket_policy" {
  statement {
    sid    = "AllowELBAccountPut"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.elb_account_id}:root"]
    }

    actions = ["s3:PutObject"]

    resources = [
      "${aws_s3_bucket.alb_access_logs.arn}/*/AWSLogs/${var.account_id}/*",
    ]
  }

  statement {
    sid    = "AllowELBLogDelivery"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }

    actions = ["s3:PutObject"]

    resources = [
      "${aws_s3_bucket.alb_access_logs.arn}/*/AWSLogs/${var.account_id}/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }

  statement {
    sid    = "AllowELBLogDeliveryAclCheck"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }

    actions = ["s3:GetBucketAcl"]

    resources = [aws_s3_bucket.alb_access_logs.arn]
  }
}

resource "aws_s3_bucket_policy" "alb_access_logs" {
  bucket = aws_s3_bucket.alb_access_logs.id
  policy = data.aws_iam_policy_document.alb_access_logs_bucket_policy.json
}
