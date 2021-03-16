# Demo VPC with bastion host

## Resume of content

This demo contains

- a vpc called `core`
- two subnets in each availability zone (1 public  / 1 private)
- security groups isolating database and bastion host
- only bastion can access database
- bastion host is in the public subnet
- database is in multi-az
- password is stored in ssm parameter store

![connection](https://imgur.com/hgV295a.png)

## How to deploy

- create/use existing private/public keys for ec2 bastion
- go to `management/us-east-2`
- change `backend.tf` and change `organization` and `workspace` to your org/workspace in terraform cloud, you can comment all block if you cannot desire backend.
- exec `terraform init` with terraform version 0.14.6+
- exec `terraform plan -var="profile=<profile-name>" -var="ssh_pkey=<your public key string>" -out=plan.apply` "profile-name" is your profile in AWS
- check all plan resources
- exec `terraform apply plan.apply`

## Improvements

- only 1 nat gateway in private subnets, we need to implement horizontal availability in all subnets, because the internet depends on only 1 subnet:

```terraform
resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = element(aws_subnet.public.*.id, local.subnet_nat_index)
  depends_on    = [aws_internet_gateway.main]
}
```

- read replica on RDS to implement
- integrate database password with aws secret manager
- enable AWS SSM session for more secure sessions
