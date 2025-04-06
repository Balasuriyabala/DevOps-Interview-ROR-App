resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = [
    aws_subnet.private1a.id,
    aws_subnet.private1b.id
  ]

  tags = {
    Name = "rds-subnet-group"
  }
}

resource "aws_db_instance" "postgres" {
  identifier             = "railsapp-db"
  engine                 = "postgres"
  engine_version         = "13.20"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  storage_type           = "gp2"
  username               = var.database_user
  password               = var.database_password
  db_name                = var.database_name
  port                   = 5432
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  multi_az               = false
  publicly_accessible    = false
  skip_final_snapshot    = true

  tags = {
    Name = "railsapp-rds"
  }
}

output "rds_endpoint" {
  value = aws_db_instance.postgres.endpoint
}