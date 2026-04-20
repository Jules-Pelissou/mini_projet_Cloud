# Politique pour augmenter la capacité 
resource "aws_autoscaling_policy" "upscale-cpu" {
  name                   = "upscale-cpu"
  autoscaling_group_name = var.nom_autoscale
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = 300
  policy_type            = "SimpleScaling"
}

# Alarme qui va permettre d'appliquer la politique d'upscle (juste au dessus)
resource "aws_cloudwatch_metric_alarm" "upscale-cpu-alarme" {
  alarm_name          = "${var.prefix_name}-upscale-cpu-alarme"
  alarm_description   = "${var.prefix_name}-upscale-cpu-alarme"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 80

  dimensions = {
    "AutoScalingGroupName" = var.nom_autoscale
  }

  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.upscale-cpu.arn]
}

# Politique pour diminuer la capacité
resource "aws_autoscaling_policy" "downscale-cpu" {
  name                   = "${var.prefix_name}-cpu-policy-scaledown"
  autoscaling_group_name = var.nom_autoscale
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1"
  cooldown               = 300
  policy_type            = "SimpleScaling"
}

# Alarme idem qu'upscale mais pour downscale
resource "aws_cloudwatch_metric_alarm" "downscale-cpu-alarme" {
  alarm_name          = "${var.prefix_name}-downscale-cpu-alarme"
  alarm_description   = "${var.prefix_name}-downscale-cpu-alarme"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 5

  dimensions = {
    "AutoScalingGroupName" = var.nom_autoscale
  }

  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.downscale-cpu.arn]
}