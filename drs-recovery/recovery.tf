###############################################################################
# DRS Recovery Instance — managed in a SEPARATE Terraform project
#
# This project is isolated from the source nginx project (separate S3 state
# key in provider.tf), so Terraform can never entangle the recovery instance
# with the source box. You now manage the two EC2 instances independently.
#
# OWNERSHIP CAVEAT (still true): these resources were launched by AWS Elastic
# Disaster Recovery (DRS). DRS controls their lifecycle -- a new recovery or
# failback job TERMINATES this instance and launches a replacement with a NEW
# id, which makes this state stale. Guard rails below keep Terraform from
# destroying or "correcting" the DRS-owned attributes:
#   - prevent_destroy = false      -> Terraform refuses to delete these
#   - ignore_changes              -> Terraform won't revert DRS-managed drift
#
# When DRS relaunches: update the ids in terraform.tfvars (or variables.tf),
# `terraform state rm` the stale resources, then re-run plan to re-import.
###############################################################################

# --- Import blocks (Terraform >= 1.5) ---------------------------------------

import {
  to = aws_instance.recovery
  id = var.recovery_instance_id
}

import {
  to = aws_ebs_volume.recovery_root
  id = var.recovery_root_volume_id
}

import {
  to = aws_network_interface.recovery_eni
  id = var.recovery_eni_id
}

import {
  to = aws_security_group.recovery_shared_sg
  id = var.recovery_security_group_id
}

import {
  to = aws_launch_template.recovery_lt
  id = var.recovery_launch_template_id
}

# --- Recovery instance ------------------------------------------------------

resource "aws_instance" "recovery" {
  ami                         = "ami-0a8bff035a5fe762d"
  instance_type               = "t3.micro"
  subnet_id                   = "subnet-0ecfe4c5f8717d497"
  availability_zone           = "ap-southeast-3c"
  private_ip                  = "10.0.23.6"
  vpc_security_group_ids      = [var.recovery_security_group_id]
  iam_instance_profile        = "ec2-role-20250227042937428400000003"
  source_dest_check           = true
  ebs_optimized               = false
  monitoring                  = false
  associate_public_ip_address = false

  tags = {
    Name                              = "drs-recovery-${var.recovery_instance_id}"
    AWSElasticDisasterRecoveryManaged = "drs.amazonaws.com"
  }

  # The instance was launched FROM the DRS launch template. Declaring the block
  # so it matches real state is what stops Terraform forcing a replacement
  # (removing a launch_template association recreates the instance).
  launch_template {
    id = var.recovery_launch_template_id
  }

  lifecycle {
    prevent_destroy = false
    # DRS owns these; never let Terraform mutate or rebuild the instance.
    ignore_changes = [
      ami,
      user_data,
      user_data_base64,
      root_block_device,
      ebs_block_device,
      network_interface,
      launch_template,
      tags,
      tags_all,
      iam_instance_profile,
      instance_type,
      associate_public_ip_address,
    ]
  }
}

# --- Root EBS volume --------------------------------------------------------

resource "aws_ebs_volume" "recovery_root" {
  availability_zone = "ap-southeast-3c"
  size              = 8
  type              = "gp3"
  iops              = 3000
  throughput        = 125
  encrypted         = true
  kms_key_id        = "arn:aws:kms:ap-southeast-3:108782069919:key/3b228a51-e521-49ed-8584-6b4869d1234f"

  tags = {
    Name = "drs-recovery-root-${var.recovery_root_volume_id}"
  }

  lifecycle {
    prevent_destroy = false
    ignore_changes  = [tags, tags_all, iops, throughput, size, type]
  }
}

# --- Primary ENI ------------------------------------------------------------

resource "aws_network_interface" "recovery_eni" {
  subnet_id       = "subnet-0ecfe4c5f8717d497"
  private_ips     = ["10.0.23.6"]
  security_groups = [var.recovery_security_group_id]

  lifecycle {
    prevent_destroy = false
    ignore_changes  = [tags, tags_all, private_ips, security_groups, attachment]
  }
}

# --- Shared security group (all-sg) -----------------------------------------
# This is a SHARED SG used by other resources too. ignore_changes prevents
# Terraform from rewriting rules it did not author; prevent_destroy stops an
# accidental delete taking the SG from everything that references it.

resource "aws_security_group" "recovery_shared_sg" {
  name   = "all-sg-20250507061911367200000002"
  vpc_id = data.aws_vpc.this.id

  lifecycle {
    prevent_destroy = false
    ignore_changes  = [ingress, egress, tags, tags_all, name, description]
  }
}

# --- DRS-managed launch template --------------------------------------------
# Fully DRS-owned; DRS bumps its versions on every config change. Imported for
# visibility only -- ignore everything.

resource "aws_launch_template" "recovery_lt" {
  name = "created-and-used-by-elastic-disaster-recovery-service-s-lca221ec40ff6106e-261410-044927"

  lifecycle {
    prevent_destroy = false
    ignore_changes  = all
  }
}
