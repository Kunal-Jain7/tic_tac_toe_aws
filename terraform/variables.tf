variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "Public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  description = "Private subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "ecr_repository_name" {
  description = "ECR repository name"
  type        = string
  default     = "tic-tac-toe-ecr"
}

variable "ecs_cluster_name" {
  description = "ECS cluster name"
  type        = string
  default     = "tic-tac-toe-cluster"
}

variable "ecs_service_name" {
  description = "ECS service name"
  type        = string
  default     = "tic-tac-toe-service"
}

variable "task_family" {
  description = "ECS task family"
  type        = string
  default     = "tic-tac-toe"
}

variable "image_tag" {
  description = "Image tag"
  type        = string
  default     = "latest"
}
