resource "aws_db_subnet_group" "main" {
  name = "${var.prefix}-main"
  depends_on = [var.vpc_db_subnets]
  subnet_ids = [
    # aws_subnet.private_a.id,
    # aws_subnet.private_b.id
    "${element(var.vpc_db_subnets, 0)}",
    "${element(var.vpc_db_subnets, 1)}"
  ]

  
  tags = var.common_tags
}

resource "aws_security_group" "rds" {
  description = "Allow access to the RDS database instance."
  name        = "${var.prefix}-rds-inbound-access"
  # vpc_id      = aws_vpc.main.id
  depends_on = [var.vpc_id]
  vpc_id = var.vpc_id
  ingress {
    protocol  = "tcp"
    from_port = 5432
    to_port   = 5432

    # allow bastion to access 
    security_groups = [
      # aws_security_group.bastion.id
      var.security_group_bastion_id
    ]

  }

  tags = var.common_tags
}

resource "aws_db_instance" "main" {
  identifier              = "${var.prefix}-${var.environment}-db"
  db_name                 = var.db_name
  allocated_storage       = 20
  storage_type            = "gp2"
  engine                  = var.db_engine
  engine_version          = var.db_engine_version
  instance_class          = var.db_class
  db_subnet_group_name    = aws_db_subnet_group.main.name
  password                = var.db_password
  username                = var.db_user
  backup_retention_period = 0
  multi_az                = false
  skip_final_snapshot     = true
  vpc_security_group_ids  = [aws_security_group.rds.id]

  tags = var.common_tags
}
