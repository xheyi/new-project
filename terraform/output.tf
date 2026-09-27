output "instance_id" {
  value = aws_instance.main.id
}

output "public_ip" {
  value = aws_eip.main.public_ip
}

output "aws_iam_role_arn_ec2" {
  value = aws_iam_role.ec2_ssm_role.arn
}

output "github_actions_role_arn" {
  value = aws_iam_role.github_actions.arn
}