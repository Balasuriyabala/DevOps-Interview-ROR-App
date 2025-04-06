# ECS Cluster
resource "aws_ecs_cluster" "app_cluster" {
  name = "rails-app-cluster"
}

# Task Execution IAM Role (for pulling ECR image, logs, etc.)
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Add logging policy attachment to execution role
resource "aws_iam_role_policy_attachment" "logging_policy_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ecs_logging_policy.arn
}

# Create a separate task role for application permissions
resource "aws_iam_role" "ecs_task_role" {
  name = "ecsTaskRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

# ECS Task Definition
resource "aws_ecs_task_definition" "app_task" {
  family                   = "rails-app-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn  # Add task role here

  container_definitions = jsonencode([
  {
    name      = "rails-container"
    image     = var.ecr_image_url
    essential = true
    portMappings = [
      {
        containerPort = 3000,
        protocol      = "tcp"
      }
    ],
#    command = ["sh", "-c", "bundle exec rails db:migrate && bundle exec rails s -b 0.0.0.0 -p 3000"]
    command = ["sh", "-c", "DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bundle exec rails db:migrate && bundle exec rails s -b 0.0.0.0 -p 3000"]
    environment = [
      {
        name  = "RDS_DB_NAME"
        value = var.database_name
      },
      {
        name  = "RDS_USERNAME"
        value = var.database_user
      },
      {
        name  = "RDS_PASSWORD"
        value = var.database_password
      },
      {
        name  = "RDS_HOSTNAME"
        value = aws_db_instance.postgres.address  
      },
      {
        name  = "RDS_PORT"
        value = "5432"  
      },
      {
        name  = "RAILS_ENV"
        value = "production"
      },
      {
        name  = "DISABLE_DATABASE_ENVIRONMENT_CHECK"
        value = "1"
      },
      {
        name  = "S3_BUCKET"
        value = var.s3_bucket_name
      }
    ],
    logConfiguration = {
      logDriver = "awslogs",
      options = {
        awslogs-group         = var.logs_group,
        awslogs-region        = var.aws_region,
        awslogs-stream-prefix = "ecs"
      }
    }
  },
  {
    name      = "nginx-container",
    image     = var.nginx_image_url, 
    essential = true,
    portMappings = [
      {
        containerPort = 80,
        protocol      = "tcp"
      }
    ],
    dependsOn = [
      {
        containerName = "rails-container",
        condition     = "START"
      }
    ],
    logConfiguration = {
      logDriver = "awslogs",
      options = {
        awslogs-group         = var.logs_group,
        awslogs-region        = var.aws_region,
        awslogs-stream-prefix = "nginx"
      }
    }
  }
])
}

# ECS Fargate Service
resource "aws_ecs_service" "app_service" {
  name            = "rails-app-service"
  cluster         = aws_ecs_cluster.app_cluster.id
  task_definition = aws_ecs_task_definition.app_task.arn
  launch_type     = "FARGATE"
  desired_count   = 2

  network_configuration {
    subnets         = [aws_subnet.private1a.id, aws_subnet.private1b.id]
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_tg.arn
    container_name   = "rails-container"
    container_port   = 3000
  }

  depends_on = [
    aws_lb_listener.http_listener
  ]
}