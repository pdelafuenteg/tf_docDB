region = "us-east-2"  #availability_zones = ["us-east-2a", "us-east-2b"]
name = "docdb"
cluster_name = "documentdb"
environement = "test"
instance_class = "db.t3.medium" #"db.r4.large"

cluster_size = 1
db_port = 27017
master_username = "dbadmin" #"admin1"
master_password = "dbpassword11" #"password1"
retention_period = 5
preferred_backup_window = "07:00-09:00"
cluster_family = "docdb3.6"
engine = "docdb"
storage_encrypted = true
skip_final_snapshot = true
apply_immediately = true
engine_version="3.6.0"


#enabled = true
#namespace = "eg"
#stage = "test"

#snapshot_identifier=""
#cluster_parameters=[]
#auto_minor_version_upgrade=true
#enabled_cloudwatch_logs_exports=[]
#cluster_dns_name=""
#reader_dns_name=""
#vpc_cidr_block =  "10.0.0.0/16"  #"172.16.0.0/16"
#zone_id=""
#allowed_security_groups=[]
#allowed_cidr_blocks=[]

#--- compute
key_name        = "docdbkey"
public_key_path = "~/.ssh/id_rsa.pub"
instance_type   = "t2.micro" #instance_type   = "t2.nano"