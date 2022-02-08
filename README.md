# tf_docDB

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

## in .zshrc

    export AWS_ACCESS_KEY_ID="xxx"
    export AWS_SECRET_ACCESS_KEY="xxx"
    export AWS_DEFAULT_REGION="us-east-2"

## generate a keypair to access EC2 instances

    ssh-keygen => ~/.ssh/id_rsa.pub

## Terraform commands
    
    terraform init
    
    terraform validate
    
    terraform plan -out=tfplan
    
    terraform apply -auto-approve tfplan
    
    terraform apply -auto-approve
    
    terraform destroy -auto-approve

## To delete Terraform state files
    rm -rfv **/.terraform # remove 
    
## To test DocumentDB
1.  ssh -i "docdbkey.pem" ec2-user@ec2-3-145-151-80.us-east-2.compute.amazonaws.com
2.  wget https://s3.amazonaws.com/rds-downloads/rds-combined-ca-bundle.pem
3.  mongo 
          --ssl 
          --host <docdb cluster endpoint>
          --sslCAFile rds-combined-ca-bundle.pem
          --username <yourMasterUsername>
          --password <yourMasterPassword>
  mongo --ssl --host testdocumentdb.cluster-cqcczwgwvdz4.us-east-2.docdb.amazonaws.com:27017 --sslCAFile rds-combined-ca-bundle.pem --username dbadmin --password
  
3.  `db.col.insert({hello:”Amazon DocumentDB”})`
4.  `db.col.find()`
5.   See more commands in connect_docDB._commands.txt or check params and run test_docDBConnect.py installing python in EC2 console
