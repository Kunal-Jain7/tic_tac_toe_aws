output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "ecr_repository_url" {
  value = module.ecr.repository_url
}

output "ecs_cluster_name" {
  value = module.ecs.cluster_name
}

output "target_group_arn" {
  value = module.ecs.target_group_arn
}

output "ecs_security_group_id" {
  value = module.ecs.ecs_security_group_id
}

output "alb_dns_name" {
  value = module.ecs.alb_dns_name
}
