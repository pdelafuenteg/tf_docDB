# Terraform - Provision an documentDB Cluster tf_docDB

This repo containing Terraform configuration files to provision an documentDB cluster on AWS.

This Terraform project shows how to specify and deploy the following components:
+ 1 module VPC ( internet gateway, 3 private subnets ans 3 public subnets for our docdb cluster )
+ 1 security group for our document db instances (port 27017)
+ 1 security group for our bastion server (port 22)


+ 1 keypair (first you have to run ssh-keygen in your home folder)
+ 1 ec2 micro instance for our bastion server

+ 1 module documentdb-cluster (cloudposse/documentdb-cluster/aws):
++ 1 docdb subnet group including the three private subnets 
++ 1 docdb cluster using the docdb subnet group
++ 1 docdb nodes (ec2 instances of type db.t3.medium / db.r4.large)

## aws configure
    aws configure
    ls -slia ~/.aws/credentials

AWS Access Key ID [****************<lastkeys>]: 
AWS Secret Access Key [****************<lastkeys>]: 
Default region name [us-east-2]: 
Default output format [json]: 
 
[
    ## in .zshrc

    export AWS_ACCESS_KEY_ID="xxx"
    export AWS_SECRET_ACCESS_KEY="xxx"
    export AWS_DEFAULT_REGION="us-east-2"
]
    
## generate a keypair to access EC2 instances (~/.ssh/id_rsa.pub y ~/.ssh/id_rsa)

    ssh-keygen
    cp ~/.ssh/id_rsa ~/.ssh/docdbkey.pem

## Terraform commands
    
    terraform init
    
    terraform validate
    
    terraform plan -out=tfplan
    
    terraform apply -auto-approve tfplan
    
    terraform apply -auto-approve
    
    terraform destroy -auto-approve

[
## To delete Terraform state files
    rm -rfv **/.terraform # remove 
]
    
## To test DocumentDB
terraform output -> bastion_ssh (ssh -A ec2-user@3.12.162.178) or ssh -A ec2-user@ec2-18-220-5-176.us-east-2.compute.amazonaws.com
terraform output -> mongo_shell (mongo --ssl --host testdocumentdb.cluster-cqcczwgwvdz4.us-east-2.docdb.amazonaws.com:27017 --sslCAFile rds-combined-ca-bundle.pem --username dbadmin --password dbpassword11)

1.  ssh -A ec2-user@<ip_public_ec2> or ( ssh -i ~/.ssh/docdbkey.pem ec2-user@<dns_public_ec2> )
2.  cd /tmp
3.  ls -lisa rds-combined-ca-bundle.pem
4.  mongo 
          --ssl 
          --host <docdb cluster endpoint>
          --sslCAFile rds-combined-ca-bundle.pem
          --username <yourMasterUsername>
          --password <yourMasterPassword>
 
mongo --ssl --host testdocumentdb.cluster-cqcczwgwvdz4.us-east-2.docdb.amazonaws.com:27017 --sslCAFile rds-combined-ca-bundle.pem --username dbadmin --password dbpassword11
  
5.  `db.col.insert({hello:”Amazon DocumentDB”})`
6.  `db.col.find()`
7.   See more commands in connect_docDB._commands.txt or check params and run test_docDBConnect.py installing python in EC2 console

## To test SSH tunnel connection  SSH tunnels to connect DocumentDB cluster from a client machine outside your VPC
ssh -i ~/.ssh/docdbkey.pem -L 27017:testdocumentdb.cluster-cqcczwgwvdz4.us-east-2.docdb.amazonaws.com:27017 ec2-user@ec2-18-220-5-176.us-east-2.compute.amazonaws.com -N

wget https://s3.amazonaws.com/rds-downloads/rds-combined-ca-bundle.pem
mongo --sslAllowInvalidHostnames --ssl --sslCAFile rds-combined-ca-bundle.pem --username <yourUsername> --password <yourPassword>
 
mongo --sslAllowInvalidHostnames --ssl --sslCAFile rds-combined-ca-bundle.pem --username dbadmin --password dbpassword11    
