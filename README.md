# aws-rancher-demo

This is an example terraform configuration to set up Rancher on AWS. This should get you started with a secure setup on 
AWS. To make it easy to use it has been simplified on several parts. So you should still do some work yourself. 


This example create a complete Rancher setup from scratch. You do need a Route 53 domain and a certificate. Registering 
a domain can be done for merely $ 10. Generating a SSL/TLS certificate to go with your domain is free when you use ACM!
This configuration places Rancher server in a private subnet. Rancher can only be reached through a Load Balancer. 
You can connect to your EC2  instances in the private subnets throught a bastion host (in a public subnet). 

## Features
- Sets up a ready to use Rancher Server on AWS from scratch
- Logging of all subnets and the external Load balancer
- Creates a record in Route 53 so you can reach Rancher server via https
- Creates an encrypted RDS cluster and creates daily backups of your snapshots. 
[Here's](https://n2ws.com/blog/3-reasons-to-start-using-rds-manual-snapshots.html) why.

## Requirements
- Terraform CLI (v0.9.11)
- AWS account
- A VPC in which the instance is to be created
- A database for the Rancher server
- A domain registered in [Route 53](http://docs.aws.amazon.com/Route53/latest/DeveloperGuide/domain-register.html)
- A SSL/TLS certificate that corresponds with the domain, either in
[ACM](http://docs.aws.amazon.com/acm/latest/userguide/gs-acm-request.html) or
[IAM](http://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_server-certs.html#upload-server-certificate)

## Usage
Alter the variables `r53_zone_id` and `certificate_arn` to match your Route 53 zone and certificate. Change the AMI's 
for the bastion host and rancher server to match the ones in your region. You can put your authorized keys in the file 
`./authorized_keys/authorized_keys`. This allows you to access your EC2 instances with ssh.
Then start terraform:

    terraform get
    terraform plan --out=demo.tfplan
    terraform apply demo.tfplan
    
Tear everything down by using:
    
    terraform destroy
    
You might need to delete your RDS instance manually afterwards.

## Notes
Although this configuration is created with security in mind you should do some stuff yourself. You should restrict 
access to your bastion host and harden it. You might want to setup your own artifact repository and docker registry. By 
doing so you can disable access from your private subnets to the big bad internet. It is also probably a good idea to 
restrict access to the external Load Balancer as well. And so on, and so on...

## One more thing
We noticed that the av zones used by the RDS cluster is sometimes changed by AWS. The first time you update your 
infrastructure please pay attention to any changes in the RDS cluster. Alter the `av_zone_list_rds` to match the new av
zones.