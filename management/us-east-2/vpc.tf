### core vpc for all resources in this case

resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block[var.region]
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = var.name
  }
}
