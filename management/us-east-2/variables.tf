variable "region" {
  default     = "us-east-2"
  description = "region of the resources"
}

variable "profile" {
  description = "profile of the resources"
}

variable "ssh_pkey" {
  description = "public-key for ssh inner ec2 instances"
}

variable "name" {
  description = "name of the vpc"
  default     = "core-vpc"
}

variable "cidr_block" {
  type        = map(string)
  description = "Base CIDR for VPC"
  default = {
    "us-east-2" : "10.200.0.0/16"
  }
}

variable "availability_zones" {
  type        = map(list(string))
  description = "Availability Zones to be used"
  default = {
    "us-east-2" : ["us-east-2a", "us-east-2b", "us-east-2c"]
  }
}

variable "public_subnet_size" {
  description = "Subnet size"
  default     = 8
}

variable "private_subnet_size" {
  description = "Subnet size for internal resources"
  default     = 4
}

### central database configuration

variable "db_name" {
  type    = string
  default = "coredb"
}


variable "db_instance_class" {
  default = "db.t2.micro"
  type    = string
}

variable "allocated_storage" {
  type    = string
  default = 100
}

variable "storage_type" {
  default = "gp2"
  type    = string
}

variable "engine" {
  type    = string
  default = "postgres"
}

variable "engine_version" {
  type    = string
  default = "12.5"
}


variable "username" {
  type    = string
  default = "core"
}


variable "db_port" {
  default     = "5432"
  description = "Insert port database"
}


