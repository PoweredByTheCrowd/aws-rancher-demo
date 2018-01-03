// Choose a name for your environment
variable "environment"                { default = "demo" }

//The Zone ID of your domain in Route53
variable "r53_zone_id"                { default = "XXXXXXXXXXXXXXX" }
//The ARN of the certificate for your domain (should be a wildcard certificate  *.example.com)
variable "certificate_arn"            { default = "arn:aws:acm:xx-xxx-1:XXXXXXXXX:certificate/xxxxx-xxxx-xxxx-xxxx-XXXXXXXXXXX" }
//The AMI for your bastion host, choose wisely
variable "bastion_ami"                { default = "ami-xxxxx" }
//The username for your database
variable "rds_user"                   { default = "demouser" }
//The password for your user, supply this when running terraform plan in the commmand line
variable "rds_password"               {}
//Database name
variable "rds_dbname"                 { default = "demorancher"}
//Place your authorized keys in this file to access your instances
variable "authorized_keys"            { default = "./authorized_keys/authorized_keys" }
// Database type
variable "rds_instance_class"         { default = "db.t2.small"}
//Put the cloud config for your bastion host in this file
variable "bastion_userdata_path"      { default = "./userdata/bastion.yml" }
//Put the cloud config for your rancher insance in this file
variable "rancher_userdata_path"      { default = "./userdata/rancher.yml"}
//The AMI of the rancher EC2 instance
variable "rancher_ami"                { default = "ami-xxxxxxx" } //See https://github.com/rancher/os/blob/master/README.md for recent RancherOs AMI's
//The version (docker tag) of Rancher you would like to use
variable "rancher_version"            { default = "preview" }

//The AV zones for your RDS instance, must match your VPC
//AWS might change this AV zones when creating your RDS, update this variable afterward,
//put an 'ignore changes' in the rds module
variable "av_zone_list_rds"           {
  type    = "list"
  default = ["us-east-1b", "us-east-1c"]
}

/*
  The identifier below is specifically for us-east-1!
  See the list below for other regions, source: http://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-access-logs.html#access-logging-bucket-permissions

  us-east-1	US East (N. Virginia)	127311923021
  us-east-2	US East (Ohio)	033677994240
  us-west-1	US West (N. California)	027434742980
  us-west-2	US West (Oregon)	797873946194
  ca-central-1	Canada (Central)	985666609251
  eu-west-1	EU (Ireland)	156460612806
  eu-central-1	EU (Frankfurt)	054676820928
  eu-west-2	EU (London)	652711504416
  ap-northeast-1	Asia Pacific (Tokyo)	582318560864
  ap-northeast-2	Asia Pacific (Seoul)	600734575887
  ap-southeast-1	Asia Pacific (Singapore)	114774131450
  ap-southeast-2	Asia Pacific (Sydney)	783225319266
  ap-south-1	Asia Pacific (Mumbai)	718504428378
  sa-east-1	South America (São Paulo)	507241528517
*/
variable "elb_identifiers"           {
  type    = "list"
  default = ["127311923021"]
}