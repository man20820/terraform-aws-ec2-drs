###############################################################################
# DRS Recovery Instance — IMPORTED (option B: import everything)
#
# WARNING — READ BEFORE APPLYING
# These resources were launched and are OWNED by AWS Elastic Disaster Recovery
# (DRS), not by this Terraform. DRS controls their full lifecycle: any new
# recovery/failback job TERMINATES this instance and launches a replacement
# with a DIFFERENT id, which invalidates this state. These blocks exist only to
# bring the CURRENT recovery artifacts under Terraform visibility.
#
# Guard rails applied to every resource below:
#   - prevent_destroy = true        -> Terraform refuses to delete these
#   - ignore_changes  = [ ... ]     -> Terraform will not try to "correct" the
#                                      DRS-managed attributes back to code
#
# To remove these from state later (e.g. after tearing the drill down):
#   terraform state rm aws_instance.drs_recovery aws_ebs_volume.drs_recovery_root \
#     aws_network_interface.drs_recovery_eni aws_security_group.drs_recovery_sg \
#     aws_launch_template.drs_recovery_lt
#   then delete this file.
###############################################################################

# --- Import blocks (Terraform >= 1.5) ---------------------------------------

import {
  to = aws_instance.drs_recovery
  id = "i-063a914ccd8d8f9b6"
}

import {
  to = aws_ebs_volume.drs_recovery_root
  id = "vol-0bdd5a65217bb12aa"
}

import {
  to = aws_network_interface.drs_recovery_eni
  id = "eni-0fb3ddcda4c4bcf47"
}

import {
  to = aws_security_group.drs_recovery_sg
  id = "sg-0c47035927e36f911"
}

import {
  to = aws_launch_template.drs_recovery_lt
  id = "lt-075c7f0ef61bd3ef2"
}

# --- Recovery instance ------------------------------------------------------

resource "aws_instance" "drs_recovery" {
  ami                         = "ami-0a8bff035a5fe762d"
  instance_type               = "t3.micro"
  subnet_id                   = "subnet-0ecfe4c5f8717d497"
  availability_zone           = "ap-southeast-3c"
  private_ip                  = "10.0.23.6"
  vpc_security_group_ids      = ["sg-0c47035927e36f911"]
  iam_instance_profile        = "ec2-role-20250227042937428400000003"
  source_dest_check           = true
  ebs_optimized               = false
  monitoring                  = false
  associate_public_ip_address = false

  tags = {
    Name                              = "drs-recovery-i-063a914ccd8d8f9b6"
    AWSElasticDisasterRecoveryManaged = "drs.amazonaws.com"
  }

  lifecycle {
    prevent_destroy = true
    # DRS owns these; never let Terraform mutate or rebuild the instance.
    ignore_changes = [
      ami,
      user_data,
      user_data_base64,
      root_block_device,
      ebs_block_device,
      network_interface,
      tags,
      tags_all,
      iam_instance_profile,
      instance_type,
      associate_public_ip_address,
    ]
  }
}

# --- Root EBS volume --------------------------------------------------------

resource "aws_ebs_volume" "drs_recovery_root" {
  availability_zone = "ap-southeast-3c"
  size              = 8
  type              = "gp3"
  iops              = 3000
  throughput        = 125
  encrypted         = true
  kms_key_id        = "arn:aws:kms:ap-southeast-3:108782069919:key/3b228a51-e521-49ed-8584-6b4869d1234f"

  tags = {
    Name = "drs-recovery-root-vol-0bdd5a65217bb12aa"
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [tags, tags_all, iops, throughput, size, type]
  }
}

# --- Primary ENI ------------------------------------------------------------

resource "aws_network_interface" "drs_recovery_eni" {
  subnet_id       = "subnet-0ecfe4c5f8717d497"
  private_ips     = ["10.0.23.6"]
  security_groups = ["sg-0c47035927e36f911"]

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [tags, tags_all, private_ips, security_groups, attachment]
  }
}

# --- Shared security group (all-sg) -----------------------------------------
# NOTE: this is a SHARED SG (all-sg-...) used by other resources too.
# ignore_changes on ingress/egress prevents Terraform from rewriting rules it
# did not author. prevent_destroy stops an accidental delete taking the SG from
# everything that references it.

resource "aws_security_group" "drs_recovery_sg" {
  name   = "all-sg-20250507061911367200000002"
  vpc_id = data.aws_vpc.this.id

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [ingress, egress, tags, tags_all, name, description]
  }
}

# --- DRS-managed launch template --------------------------------------------
# Fully DRS-owned; DRS bumps its versions on every config change. We import for
# visibility only and ignore everything.

resource "aws_launch_template" "drs_recovery_lt" {
  name = "created-and-used-by-elastic-disaster-recovery-service-s-lca221ec40ff6106e-261410-044927"

  lifecycle {
    prevent_destroy = true
    ignore_changes  = all
  }
}
