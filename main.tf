module "network" {
  source              = "github.com/PoweredByTheCrowd/terraform-aws-network"
  environment         = "${var.environment}"
  bastion_ami         = "${var.bastion_ami}"
  userdata_path       = "${var.bastion_userdata_path}"
  authorized_keys     = "${var.authorized_keys}"
}

module "rds" {
  source              = "github.com/PoweredByTheCrowd/terraform-rds"
  environment         = "${var.environment}"
  vpc_id              = "${module.network.vpc_id}"
  rds_user            = "${var.rds_user}"
  rds_dbname          = "${var.rds_dbname}"
  rds_password        = "${var.rds_password}"
  subnet_list         = "${module.network.private_subnet_list}"
  av_zone_list        = "${var.av_zone_list_rds}"
  security_group_list = "${list(module.network.bastion_sg)}"
  rds_instance_class  = "${var.rds_instance_class}"
}

module "rancher" {
  source              = "github.com/PoweredByTheCrowd/terraform-rancher"
  environment         = "${var.environment}"
  vpc_id              = "${module.network.vpc_id}"
  r53_zone_id         = "${var.r53_zone_id}"
  certificate_arn     = "${var.certificate_arn}"
  rancher_ami         = "${var.rancher_ami}"
  rancher_version     = "${var.rancher_version}"
  bastion_cidr_blocks = "${list(module.network.bastion-instance-private-cidr)}"
  sg_rds_access       = "${module.rds.sg_rds_access}"
  rds_host            = "${module.rds.rds_cluster_endpoint}"
  rds_user            = "${var.rds_user}"
  rds_dbname          = "${var.rds_dbname}"
  rds_password        = "${var.rds_password}"
  subnet_private_list = "${module.network.private_subnet_list}"
  subnet_public_list  = "${module.network.public_subnet_list}"
  userdata_path       = "${var.rancher_userdata_path}"
  elb_identifiers     = "${var.elb_identifiers}"
  authorized_keys     = "${var.authorized_keys}"
}

output "00. rancher url"          { value = "https://${module.rancher.rancher_url}"}
output "01. bastion ip"           { value = "${module.network.bastion-instance-ip}"}
output "02. rancher internal ip"  { value = "${module.rancher.ec2-instance-private-ip}"}
output "03. rancher internal url" { value = "${module.rancher.rancher_internal_url}"}
output "04. http target group"    { value = "${module.rancher.http_target_group_arn}"}
output "04. https target group"   { value = "${module.rancher.https_target_group_arn}"}
output "05. rancher host sg"      { value = "${module.rancher.rancher-machine-sg}"}
output "06. private subnets"      { value = "${module.network.private_subnet_list}"}