locals {
  netnum_public = 0
  #netnum 5 in /20 is equivalent a  10.x.80.0/20, this range is equivalent a 80 numbers in /24 network
  # this equivalent is to avoid ip collisions in differents subnets
  netnum_private = 5
  subnet_count   = length(var.availability_zones[var.region])
  # only one nat gateway for the private access in one zone
  subnet_nat_index = 0
  # s3 bucket for ssm 
  s3_bucket = "core-${var.region}-ssm-logs"
  # logs ssm prefix
  ssm_prefix = "/core/ssm"
}

