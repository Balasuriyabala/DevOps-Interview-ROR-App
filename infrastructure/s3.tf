# S3 Bucket
resource "aws_s3_bucket" "app_bucket" {
  bucket = var.s3_bucket_name

  tags = {
    Name = "rails-app-s3-bucket"
  }
}

# IAM Policy to access S3
resource "aws_iam_policy" "s3_access_policy" {
  name        = "ecs-s3-access-policy"
  description = "Allow ECS task access to S3 bucket"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:DeleteObject"
        ]
        Resource = [
          aws_s3_bucket.app_bucket.arn,
          "${aws_s3_bucket.app_bucket.arn}/*"
        ]
      }
    ]
  })
}

# Just attach S3 access to existing role
resource "aws_iam_role_policy_attachment" "attach_s3_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

resource "aws_iam_policy" "ecs_logging_policy" {
        name        = "ecs_logging_policy"
        description = "Allows ECS tasks to send logs to CloudWatch"

        policy = jsonencode({
                Version = "2012-10-17",
                Statement = [
                        {
                                Effect = "Allow",
                                Action = [
                                        "logs:CreateLogStream",
                                        "logs:PutLogEvents",
                                        "logs:CreateLogGroup"
                                ],
                                Resource = "arn:aws:logs:*:*:*"
                        },
                ]
        })
}
