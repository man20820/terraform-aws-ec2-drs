###############################################################################
# EC2 Instance — Nginx with simple HTML test page
###############################################################################

module "ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 5.6"

  name = "${var.project_name}-nginx"

  ami           = data.aws_ssm_parameter.al2023.value
  instance_type = var.instance_type
  key_name      = var.key_pair_name

  subnet_id              = data.aws_subnet.private.id
  vpc_security_group_ids = [module.ec2_sg.security_group_id]

  user_data = base64encode(templatefile("${path.module}/templates/user_data.sh", {
    project_name = var.project_name
  }))

  user_data_replace_on_change = true

  tags = merge(var.tags, {
    Name = "${var.project_name}-nginx"
  })
}
