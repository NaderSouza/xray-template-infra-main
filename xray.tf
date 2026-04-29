###############################################################################
# X-Ray Sampling Rules — FrontConsig
###############################################################################

# Production: 5% sampling to control costs
resource "aws_xray_sampling_rule" "frontconsig_prod" {
  rule_name      = "frontconsig-prod"
  priority       = 100
  version        = 1
  reservoir_size = 1
  fixed_rate     = 0.05
  url_path       = "*"
  host           = "*"
  http_method    = "*"
  service_type   = "*"
  service_name   = "frontconsig-*"
  resource_arn   = "*"

  attributes = {}

  tags = {
    Environment = "prod"
  }
}

# Non-production: 100% sampling for full debug
resource "aws_xray_sampling_rule" "frontconsig_non_prod" {
  rule_name      = "frontconsig-non-prod"
  priority       = 200
  version        = 1
  reservoir_size = 10
  fixed_rate     = 1.0
  url_path       = "*"
  host           = "*"
  http_method    = "*"
  service_type   = "*"
  service_name   = "frontconsig-*-dev,frontconsig-*-homolog"
  resource_arn   = "*"

  attributes = {}

  tags = {
    Environment = "non-prod"
  }
}

###############################################################################
# X-Ray Group
###############################################################################

resource "aws_xray_group" "frontconsig" {
  group_name        = "FrontConsig"
  filter_expression = "service(\"frontconsig-*\")"

  insights_configuration {
    insights_enabled      = true
    notifications_enabled = true
  }
}
