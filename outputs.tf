output "arn" {
  value       = module.documentdb-cluster.arn
  description = "Amazon Resource Name (ARN) of the DocumentDB cluster"
}

output "cluster_name" {
  description = "DocumentDB cluster Name."
  value       =  module.documentdb-cluster.cluster_name
}

output "endpoint" {
  description = "Endpoint of the DocumentDB cluster."
  value       = module.documentdb-cluster.endpoint
}

output "master_host" {
  value       = module.documentdb-cluster.master_host
  description = "DocumentDB master hostname"
}

output "master_username" {
  value       = module.documentdb-cluster.master_username
  description = "DocumentDB Username for the master DB user"
}

#output "private_subnet_cidrs" {
#  value       = module.documentdb-cluster.private_subnet_cidrs
#  description = "Private subnet CIDRs"
#}

#output "public_subnet_cidrs" {
#  value       = module.documentdb-cluster.public_subnet_cidrs
#  description = "Public subnet CIDRs"
#}

output "reader_endpoint" {
  value       = module.documentdb-cluster.reader_endpoint
  description = "Read-only endpoint of the DocumentDB cluster, automatically load-balanced across replicas"
}

output "replicas_host" {
  value       = module.documentdb-cluster.replicas_host
  description = "DocumentDB replicas hostname"
}

output "security_group_arn" {
  value       = module.documentdb-cluster.security_group_arn
  description = "ARN of the DocumentDB cluster Security Group"
}

output "security_group_id" {
  description = "Security group ids attached to the cluster DocumentDB."
  value       = module.documentdb-cluster.security_group_id
}

output "security_group_name" {
  value       = module.documentdb-cluster.security_group_name
  description = "Name of the DocumentDB cluster Security Group"
}

output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "VPC ID"
}

output "region" {
  description = "AWS region"
  value       = var.region
}

#--- compute/outputs.tf
output "keypair_id" {
  value = "${join(", ", aws_key_pair.keypair.*.id)}"
}
output "bastion_ids" {
  value = "${join(", ", aws_instance.bastion.*.id)}"
}
output "bastion_public_ips" {
  value = "${join(", ", aws_instance.bastion.*.public_ip)}"
}

output "bastion_ssh" {
  value = "ssh -A ec2-user@${join(", ", aws_instance.bastion.*.public_ip)}"
}

output "mongo_shell" {
  value = "mongo --ssl --host ${module.documentdb-cluster.endpoint}:${var.db_port} --sslCAFile rds-combined-ca-bundle.pem --username ${var.master_username} --password ${var.master_password}"
}