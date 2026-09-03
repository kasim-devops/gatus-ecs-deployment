# Create ECS cluster
resource "aws_ecs_cluster" "gatus-cluster" {
  name = "gatus-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

# IAM Task Execution Role
resource "aws_iam_role" "ecs_execution_role" {
  name = "gatus-ecs-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
}

# IAM Policy Attachment for ECS Task Execution Role
resource "aws_iam_role_policy_attachment" "gatus-attach" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "gatus-log-group" {
  name              = "/ecs/gatus"
  retention_in_days = 7
}

# ECS Task Definition
resource "aws_ecs_task_definition" "gatus-task" {
  family                   = "gatus-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory

  execution_role_arn = aws_iam_role.ecs_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "gatus-container"
      image     = var.gatus_image
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.gatus-log-group.name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "gatus"
        }
      }
    }
  ])
}

# ECS Service
resource "aws_ecs_service" "gatus-service" {
  name            = "gatus-service"
  cluster         = aws_ecs_cluster.gatus-cluster.id
  task_definition = aws_ecs_task_definition.gatus-task.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  health_check_grace_period_seconds = 90

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [var.ecs_security_group_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "gatus-container"
    container_port   = 8080
  }

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }
}