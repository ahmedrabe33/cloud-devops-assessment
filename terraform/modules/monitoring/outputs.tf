output "ecs_cpu_alarm_name" {
  value = aws_cloudwatch_metric_alarm.ecs_cpu_high.alarm_name
}
