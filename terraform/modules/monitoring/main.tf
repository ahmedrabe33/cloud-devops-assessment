resource "aws_cloudwatch_metric_alarm" "ecs_cpu_high" {
  alarm_name          = "${var.project_name}-${var.environment}-ecs-cpu-high"
  alarm_description   = "Alert when ECS service CPU exceeds 80 percent"
  comparison_operator = "GreaterThanThreshold"

  evaluation_periods = 2
  threshold          = 80

  metric_name = "CPUUtilization"
  namespace   = "AWS/ECS"
  period      = 60
  statistic   = "Average"

  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = var.ecs_service_name
  }

  treat_missing_data = "notBreaching"

  tags = {
    Name = "${var.project_name}-${var.environment}-ecs-cpu-high"
  }
}
