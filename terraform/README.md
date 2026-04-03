# Terraform Infrastructure for Tic-Tac-Toe ECS Deployment

This Terraform configuration creates the necessary AWS infrastructure for deploying the Tic-Tac-Toe application on ECS.

## Modules

- **vpc**: Creates a VPC with public and private subnets, internet gateway, NAT gateways, and route tables.
- **ecr**: Creates an ECR repository for storing Docker images.
- **ecs**: Creates an ECS cluster, load balancer, target group, security groups, IAM roles, and task definition.

## Variables

- `image_tag`: The Docker image tag to use for the task definition (default: "latest"). This is updated by Jenkins after building the image.

## Usage

1. Update the variables in `variables.tf` as needed (e.g., AWS region, account ID).
2. Initialize Terraform:
   ```
   terraform init
   ```
3. Plan the deployment:
   ```
   terraform plan
   ```
4. Apply the configuration:
   ```
   terraform apply
   ```

## Outputs

- `vpc_id`: VPC ID
- `public_subnets`: List of public subnet IDs
- `private_subnets`: List of private subnet IDs
- `ecr_repository_url`: ECR repository URL
- `ecs_cluster_name`: ECS cluster name
- `target_group_arn`: ALB target group ARN
- `ecs_security_group_id`: ECS security group ID
- `alb_dns_name`: ALB DNS name for accessing the application

## Notes

- The ECS service is created dynamically by Jenkins after the infrastructure is provisioned.
- The task definition is managed by Terraform and updated by Jenkins with the built image tag.
- For production, consider adding HTTPS to the ALB and adjusting security groups.
