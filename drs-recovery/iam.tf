###############################################################################
# IAM policy attachments for DRS failback
#
# "Protect recovered instance" / "Start reversed replication" require the
# recovery instance's role to have the DRS recovery-instance and agent
# permissions. These attach AWS-managed policies to the EXISTING shared role
# without importing or mutating the role resource itself.
#
#   - AWSElasticDisasterRecoveryRecoveryInstancePolicy
#       Lets the recovery instance register as a DRS recovery instance and
#       participate in failback.
#   - AWSElasticDisasterRecoveryEc2InstancePolicy
#       Runtime permissions for the DRS replication agent (recovery instance
#       acts as a source during reverse replication).
#   - AWSElasticDisasterRecoveryAgentInstallationPolicy
#       Allows the failback/replication agent to (re)install and authenticate
#       via the instance role.
###############################################################################

resource "aws_iam_role_policy_attachment" "recovery_drs_recovery_instance" {
  role       = var.recovery_instance_role_name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticDisasterRecoveryRecoveryInstancePolicy"
}

resource "aws_iam_role_policy_attachment" "recovery_drs_ec2_instance" {
  role       = var.recovery_instance_role_name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticDisasterRecoveryEc2InstancePolicy"
}

resource "aws_iam_role_policy_attachment" "recovery_drs_agent_install" {
  role       = var.recovery_instance_role_name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticDisasterRecoveryAgentInstallationPolicy"
}
