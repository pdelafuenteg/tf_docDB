data "aws_availability_zones" "available" {}

module "vpc" {
  
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.2.0"

  name                 = "tf-${var.name}-vpc" #"docdb-vpc" #"education-vpc"
  cidr                 = "10.0.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  
  enable_dns_support = true
  enable_vpn_gateway = true
  
}

resource "aws_security_group" "service" {
  #name_prefix = "all_worker_management"
  name        = "tf-${var.name}-sg"
  vpc_id      = module.vpc.vpc_id

  ingress {
   # from_port = 0
   # to_port   = 0
    
    from_port   = 27017
    to_port     = 27017
    protocol  = "tcp"
    #protocol        = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

# # https://www.terraform.io/docs/providers/aws/r/docdb_cluster.html

# resource "aws_docdb_subnet_group" "service" {
#   name       = "tf-${var.name}-subnet-group"
#   subnet_ids = ["${module.vpc.public_subnets}"]
# }


# resource "aws_docdb_cluster" "service" {
  
  
#   cluster_identifier      = var.cluster_name #"tf-${var.name}"
#   engine                  = var.engine #"docdb"
#   master_username         = var.master_username
#   master_password         = var.master_password
#   port                    = var.db_port

#   db_subnet_group_name    = aws_docdb_subnet_group.service.name
#   db_cluster_parameter_group_name = aws_docdb_cluster_parameter_group.service.name
#   vpc_security_group_ids = [aws_security_group.service.id]

#   backup_retention_period = var.retention_period
#   preferred_backup_window = var.preferred_backup_window
  
#   skip_final_snapshot = var.skip_final_snapshot
#   storage_encrypted = var.storage_encrypted


# }

# resource "aws_docdb_cluster_parameter_group" "service" {
#   family = var.cluster_family #"docdb3.6"
#   name = "tf-${var.name}-cluster-par-group"

#   parameter {
#     name  = "tls"
#     value = "disabled"
#   }

# }

# # https://www.terraform.io/docs/providers/aws/r/docdb_cluster_instance.html

# resource "aws_docdb_cluster_instance" "service" {
#   count              = 1 #var.cluster_size #1
#   identifier         = "tf-${var.name}-${count.index}"
#   cluster_identifier = aws_docdb_cluster.service.id
#   instance_class     = var.instance_class #"${var.docdb_instance_class}"
# }


module "documentdb-cluster" {
 source                          = "cloudposse/documentdb-cluster/aws"
 version                         = "0.14.1"
  # insert the 14 required variables here
  #namespace                       = "grd"
  name                            = var.cluster_name
  #stage                           = "test"

  cluster_size                    = var.cluster_size
  master_username                 = var.master_username
  master_password                 = var.master_password
  instance_class                  = var.instance_class #"db.t3.medium" or large:  "db.r4.large"
  db_port                         = var.db_port

  delimiter                       = ""
  enabled                         = true
  environment                     = var.environement
  id_length_limit                 = 0
  vpc_id                          = module.vpc.vpc_id
  subnet_ids                      = module.vpc.private_subnets
#  subnet_ids                     = [ tolist(module.vpc.private_subnets.ids)[0], tolist(module.vpc.private_subnets.ids)[1], tolist(module.vpc.private_subnets.ids)[2] ]
#  #subnet_ids                     = module.vpc.private_subnet_ids #EKS => subnets = module.vpc.private_subnets
#  #subnet_ids                     = [aws_subnet.subnet_docdb_1.id, aws_subnet.subnet_docdb_2.id]

  zone_id                         = var.zone_id
  apply_immediately               = var.apply_immediately
  auto_minor_version_upgrade      = var.auto_minor_version_upgrade
  #allowed_security_groups         = var.allowed_security_groups # ##allowed_security_groups = [aws_security_group.sg_docdb.id]
  #allowed_cidr_blocks             = var.allowed_cidr_blocks # ##allowed_cidr_blocks     = ["172.32.0.0/16"]
  
  snapshot_identifier             = var.snapshot_identifier
  retention_period                = var.retention_period
  preferred_backup_window         = var.preferred_backup_window
  preferred_maintenance_window    = var.preferred_maintenance_window
  #cluster_parameters              = var.cluster_parameters
  cluster_family                  = var.cluster_family
  engine                          = var.engine
  engine_version                  = var.engine_version
  storage_encrypted               = var.storage_encrypted
  #kms_key_id                      = var.kms_key_id
  skip_final_snapshot             = var.skip_final_snapshot
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  
  cluster_dns_name                = var.cluster_dns_name
  reader_dns_name                 = var.reader_dns_name
  
  #vpc_security_group_ids          = [ aws_security_group.all_worker_mgmt.*.id ]
  #db_subnet_group_name            = join("", aws_docdb_subnet_group.default.*.name)
  #db_cluster_parameter_group_name = join("", aws_docdb_cluster_parameter_group.default.*.name)
  #vpc_security_group_ids          = [join("", aws_security_group.default.*.id)]
  #db_subnet_group_name            = join("", aws_docdb_subnet_group.default.*.name)
  #db_cluster_parameter_group_name = join("", aws_docdb_cluster_parameter_group.default.*.name)
  allowed_security_groups          = [aws_security_group.service.id]
  
}

#--- compute/main.tf

#resource "tls_private_key" "instance" {
#  algorithm = "RSA"
#}

resource "aws_key_pair" "keypair" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
   tags = {
    Name = var.key_name
  }

}

data "aws_ami" "ami" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn-ami-hvm*-x86_64-gp2"]
  }
}
data "template_file" "userdata" {
  count = 1

  template = file("userdata.tpl")
  vars = { 
    ec2_index = count.index
  }
}
resource "aws_instance" "bastion" {
  count = 1

  instance_type           = var.instance_type
  ami                     = data.aws_ami.ami.id
  #key_name                = aws_key_pair.keypair.id
  key_name                = aws_key_pair.keypair.key_name
  subnet_id               = module.vpc.public_subnets[0]
  
  #subnet_id               = element( module.vpc.public_subnets.*.ids, 0)
  #vpc_security_group_ids  = [ module.vpc.default_security_group_id ]
  #vpc_security_group_ids  = [var.sgbastion_id]
  #vpc_security_group_ids  = [ aws_security_group.service.id ]
  vpc_security_group_ids  = [ aws_security_group.service.id, aws_security_group.bastion.id ]

  user_data               = data.template_file.userdata.*.rendered[count.index]
  tags = { 
    name = format("%s_bastion_%d", var.name, count.index)
    project_name = var.name
  }
  associate_public_ip_address = true
  
}

resource "aws_security_group" "bastion" {

 #name_prefix = "all_worker_management"
  name        = "tf-${var.name}-bastion-sg"
  description = "Allow SSH traffic to bastion"
  vpc_id      = module.vpc.vpc_id

  ingress {
    #from_port = 0
    #to_port   = 0
    from_port   = 22
    to_port     = 22
    protocol  = "tcp"
    #protocol        = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # ingress {
  #   from_port = 0
  #   to_port   = 0
  #   #from_port   = 22
  #   #to_port     = 22
  #   #protocol  = "tcp"
  #   protocol        = "-1"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

}