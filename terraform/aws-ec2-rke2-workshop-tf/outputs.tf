output "timestamp" {
  value       = timestamp()
  description = "Create/Update Timestamp"
}

output "vpc_id" {
  value       = [aws_vpc.aws_rke2_vpc.id]
  description = "VPC ID for the AWS RKE2 cluster"
}

output "subnet_ids" {
  value       = [aws_subnet.aws_rke2_subnet.id]
  description = "Subnet IDs for the AWS RKE2 cluster"
}

output "instance_ips_studenta" {
  value       = ["${aws_instance.aws_ec2_instance_studenta.*.public_ip}"]
  description = "Instance IPs for studenta in the AWS RKE2 cluster"
}

output "instance_ips_studentb" {
  value       = ["${aws_instance.aws_ec2_instance_studentb.*.public_ip}"]
  description = "Instance IPs for studentb in the AWS RKE2 cluster"
}

output "instance_ips_studentc" {
  value       = ["${aws_instance.aws_ec2_instance_studentc.*.public_ip}"]
  description = "Instance IPs for studentc in the AWS RKE2 cluster"
}