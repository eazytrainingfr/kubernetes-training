Installing minikube on an EC2 machine with Terraform  

1. Create and download a public key from AWS and put it in the same directory as the ec2.tf file
2. Creat access key and secret key
3. Go to the directory which contains your public key and the ec2.tf file, then execute the following commands:
```
terraform init
```
```
terraform plan
```
```
terraform apply --auto-approve
```

to delete all resources  
```
terraform apply --auto-approve
```

4. Once the execution of the terraform apply command is complete, open the newly created infos_ec2.txt file to retrieve the public IP of EC2