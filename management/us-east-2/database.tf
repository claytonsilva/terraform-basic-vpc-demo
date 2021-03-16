#### central database configuration 
### this central database dont contain read-replica yet
###########

resource "aws_security_group" "database" {
  name        = "databse"
  description = "Database Security Group ${var.db_name}"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "internal_conn" {
  description       = "enable internal connection when replica exists"
  type              = "ingress"
  from_port         = var.db_port
  to_port           = var.db_port
  protocol          = "tcp"
  self              = true
  security_group_id = aws_security_group.database.id
}



resource "aws_db_subnet_group" "database" {
  name        = var.name
  description = "Database Subnet Group ${var.db_name}"
  subnet_ids  = aws_subnet.private.*.id

  tags = {
    Name = var.db_name
  }
}

resource "aws_ssm_parameter" "core_database_password" {
  name  = "/Core/Database/password"
  type  = "String"
  value = "REDACTED"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_db_instance" "master" {
  allocated_storage = var.allocated_storage
  storage_type      = var.storage_type
  engine            = var.engine
  engine_version    = var.engine_version
  instance_class    = var.db_instance_class

  identifier          = var.db_name
  name                = var.db_name
  username            = var.username
  publicly_accessible = false
  password            = "willb3changed"

  auto_minor_version_upgrade = true
  backup_retention_period    = 7
  backup_window              = "04:00-04:30"
  copy_tags_to_snapshot      = true
  maintenance_window         = "sun:04:30-sun:05:30"
  skip_final_snapshot        = true
  db_subnet_group_name       = aws_db_subnet_group.database.name
  multi_az                   = true
  port                       = var.db_port
  vpc_security_group_ids     = [aws_security_group.database.id]

  tags = {
    Name = var.db_name
  }

  provisioner "local-exec" {
    command = "${path.module}/scripts/update-database-password.sh ${var.profile} ${var.region} ${self.id} ${aws_ssm_parameter.core_database_password.name}"
  }

  lifecycle {
    ignore_changes = [password]
  }

  depends_on = [aws_ssm_parameter.core_database_password]
}
