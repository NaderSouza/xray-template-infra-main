###############################################################################
# CloudWatch Dashboard — FrontConsig X-Ray Observability
###############################################################################

resource "aws_cloudwatch_dashboard" "xray" {
  dashboard_name = "FrontConsig-XRay"

  dashboard_body = jsonencode({
    widgets = [
      # Service Map link
      {
        type   = "text"
        x      = 0
        y      = 0
        width  = 24
        height = 3
        properties = {
          markdown = "## FrontConsig X-Ray Observability\n[Service Map](https://${var.region}.console.aws.amazon.com/xray/home?region=${var.region}#/service-map) | [Traces](https://${var.region}.console.aws.amazon.com/xray/home?region=${var.region}#/traces) | [Analytics](https://${var.region}.console.aws.amazon.com/xray/home?region=${var.region}#/analytics) | [Insights](https://${var.region}.console.aws.amazon.com/xray/home?region=${var.region}#/insights) | [S3 ALB Logs](https://s3.console.aws.amazon.com/s3/buckets/akrk-alb-access-logs-${var.account_id})"
        }
      },

      # Traces Processed
      {
        type   = "metric"
        x      = 0
        y      = 3
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/X-Ray", "ApproximateTraceCount", "GroupName", "FrontConsig", { stat = "Sum", period = 300 }]
          ]
          view    = "timeSeries"
          stacked = false
          region  = var.region
          title   = "Trace Count"
          period  = 300
        }
      },

      # Fault Count (5xx)
      {
        type   = "metric"
        x      = 12
        y      = 3
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/X-Ray", "FaultCount", "GroupName", "FrontConsig", { stat = "Sum", period = 300 }]
          ]
          view    = "timeSeries"
          stacked = false
          region  = var.region
          title   = "Faults (5xx)"
          period  = 300
        }
      },

      # Error Count (4xx)
      {
        type   = "metric"
        x      = 0
        y      = 9
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/X-Ray", "ErrorCount", "GroupName", "FrontConsig", { stat = "Sum", period = 300 }]
          ]
          view    = "timeSeries"
          stacked = false
          region  = var.region
          title   = "Errors (4xx)"
          period  = 300
        }
      },

      # Throttle Count
      {
        type   = "metric"
        x      = 12
        y      = 9
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/X-Ray", "ThrottleCount", "GroupName", "FrontConsig", { stat = "Sum", period = 300 }]
          ]
          view    = "timeSeries"
          stacked = false
          region  = var.region
          title   = "Throttles (429)"
          period  = 300
        }
      },

      # Response Time P95
      {
        type   = "metric"
        x      = 0
        y      = 15
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/X-Ray", "ResponseTime", "GroupName", "FrontConsig", { stat = "p95", period = 300 }]
          ]
          view    = "timeSeries"
          stacked = false
          region  = var.region
          title   = "Latency P95"
          period  = 300
        }
      },

      # Response Time P50
      {
        type   = "metric"
        x      = 12
        y      = 15
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/X-Ray", "ResponseTime", "GroupName", "FrontConsig", { stat = "p50", period = 300 }]
          ]
          view    = "timeSeries"
          stacked = false
          region  = var.region
          title   = "Latency P50"
          period  = 300
        }
      },
    ]
  })
}
