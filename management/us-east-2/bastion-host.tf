### bastion host for direct access in database

resource "aws_security_group" "bastion" {
  name        = "bastion"
  description = "Security group of Bastion"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_security_group_rule" "from_internet_to_bastion" {
  description       = "enable ssh port from internet (demo case only)"
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bastion.id
}


resource "aws_security_group_rule" "from_bastion_to_database" {
  description              = "enable access db connection from bastion host"
  type                     = "ingress"
  from_port                = var.db_port
  to_port                  = var.db_port
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.bastion.id
  security_group_id        = aws_security_group.database.id
}



resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key-core"
  public_key = var.ssh_pkey
}


data "aws_ami" "amazon_linux_2_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}



resource "aws_instance" "bastion" {
  ami           = data.aws_ami.amazon_linux_2_ami.id
  instance_type = "t3.micro"

  # deploy on first zone
  subnet_id       = element(aws_subnet.public.*.id, 0)
  security_groups = [aws_security_group.bastion.id]

  key_name = aws_key_pair.deployer.id

  tags = {
    Name = "Bastion"
  }

  lifecycle {
    ignore_changes = [security_groups]
  }
}

