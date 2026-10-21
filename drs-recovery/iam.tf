###############################################################################
# IAM policy attachments for DRS failback
#
# "Protect recovered instance" / "Start reversed replication" require the
# recovery instance's role to have the DRS recovery-instance and agent
# permissions. These attach AWS-managed policies to the EXISTING role
# WITHOUT importing or mutating the role resource itself.
#
# NOTE: `iam_instance_profile` on the recovery instance is the INSTANCE
# PROFILE name, which is NOT necessarily the ROLE name. We resolve the real
# role name from the instance profile via a data source so the attachments
# target the correct role.
###############################################################################

# Resolve the instance profile, then read the role it contains.
data "aws_iam_instance_profile" "recovery" {
  name = var.recovery_instance_profile_name
}

locals {
  # The role actually used by the recovery instance's instance profile.
  recovery_role_name = data.aws_iam_instance_profile.recovery.role_name
}

resource "aws_iam_role_policy_attachment" "recovery_drs_recovery_instance" {
  role       = local.recovery_role_name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticDisasterRecoveryRecoveryInstancePolicy"
}

resource "aws_iam_role_policy_attachment" "recovery_drs_ec2_instance" {
  role       = local.recovery_role_name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticDisasterRecoveryEc2InstancePolicy"
}

resource "aws_iam_role_policy_attachment" "recovery_drs_agent_install" {
  role       = local.recovery_role_name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticDisasterRecoveryAgentInstallationPolicy"
}
