output "cluster_name" {
  value = aws_ecs_cluster.main.name
}

output "target_group_arn" {
  value = aws_lb_target_group.main.arn
}

output "ecs_security_group_id" {
  value = aws_security_group.ecs.id
}

output "alb_dns_name" {
  value = aws_lb.main.dns_name
}
