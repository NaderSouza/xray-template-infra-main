###############################################################################
# IAM Role + Policy for ECS Tasks to send X-Ray traces
###############################################################################

data "aws_iam_policy_document" "xray_ecs_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "xray_ecs_role" {
  name               = "xray-ecs-task-role"
  assume_role_policy = data.aws_iam_policy_document.xray_ecs_assume_role.json

  tags = {
    Purpose = "Allow ECS tasks to send X-Ray traces"
  }
}

data "aws_iam_policy_document" "xray_permissions" {
  statement {
    sid    = "XRayTracing"
    effect = "Allow"
    actions = [
      "xray:PutTraceSegments",
      "xray:PutTelemetryRecords",
      "xray:GetSamplingRules",
      "xray:GetSamplingTargets",
      "xray:GetSamplingStatisticSummaries",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "xray_ecs_policy" {
  name        = "xray-ecs-tracing-policy"
  description = "Allows ECS tasks to send traces and telemetry to AWS X-Ray"
  policy      = data.aws_iam_policy_document.xray_permissions.json
}

resource "aws_iam_role_policy_attachment" "xray_ecs_attach" {
  role       = aws_iam_role.xray_ecs_role.name
  policy_arn = aws_iam_policy.xray_ecs_policy.arn
}
