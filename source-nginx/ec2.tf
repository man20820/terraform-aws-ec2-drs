###############################################################################
# EC2 Instance — Nginx with simple HTML test page
###############################################################################

module "ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 6.0"

  name = "${var.project_name}-nginx"

  # ami           = data.aws_ssm_parameter.ubuntu2404.value
  ami           = "ami-00e3b0c0a0de782cb"
  instance_type = var.instance_type
  key_name      = var.key_pair_name

  subnet_id                   = data.aws_subnet.public.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [module.ec2_sg.security_group_id]

  user_data = templatefile("${path.module}/templates/user_data.sh", {
    project_name = var.project_name
  })

  user_data_replace_on_change = false

  # IAM instance profile so the AWS DRS replication agent authenticates
  # via the instance role instead of static access keys.
  create_iam_instance_profile = true
  iam_role_name               = "${var.project_name}-drs-agent-role"
  iam_role_use_name_prefix    = false
  iam_role_policies = {
    drs_agent_install = "arn:aws:iam::aws:policy/AWSElasticDisasterRecoveryAgentInstallationPolicy"
    drs_agent_runtime = "arn:aws:iam::aws:policy/service-role/AWSElasticDisasterRecoveryEc2InstancePolicy"
  }

  # NOTE: AWS DRS-managed tags (AWSDRS, AWSElasticDisasterRecovery*) are left
  # to DRS. The provider's ignore_tags block (see provider.tf) keeps Terraform
  # from stripping them, so they are intentionally NOT listed here.
  tags = merge(var.tags, {
    Name = "${var.project_name}-nginx"
  })
}
