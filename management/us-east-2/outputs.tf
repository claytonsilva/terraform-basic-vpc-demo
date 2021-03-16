output "bastion_host_ip" {
  description = "public ip of the bastion for direct access"
  value       = aws_instance.bastion.public_ip
}

output "database_host" {
  description = "database host for connection inner bastion"
  value       = aws_db_instance.master.address
}
