resource "aws_iam_instance_profile" "private_instance_profile" {
  name = "${local.system_key}-private-instance-profile"
  role = aws_iam_role.private_instance_role.name
}

resource "aws_iam_role" "private_instance_role" {
  name = "${local.system_key}-private-instance-role"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ssm_role_policy" {
  depends_on = [
    aws_iam_role.private_instance_role
  ]
  role       = "${local.system_key}-private-instance-role"
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_policy" "ssm-additonal_policy" {
  name   = "${local.system_key}-ssm-additonal-policy"
  policy = templatefile("templates/ssm-additional-policy.json.tpl",
    {
      ACCOUNT_ID = var.account_id
    }
  )
}

resource "aws_iam_role_policy_attachment" "kms_role_policy" {
  depends_on = [
    aws_iam_role.private_instance_role
  ]
  role       = "${local.system_key}-private-instance-role"
  policy_arn = aws_iam_policy.ssm-additonal_policy.arn
}