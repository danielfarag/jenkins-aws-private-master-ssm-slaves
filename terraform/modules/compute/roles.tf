resource "aws_iam_role" "ec2_ssm" {
  name = "ec2_ssm"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name = "EC2 Assume SSM"
  }
}


resource "aws_iam_role_policy_attachment" "attach_ssm_ec2_managed" {
  role       = aws_iam_role.ec2_ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}


resource "aws_iam_policy" "s3_bucket" {
  name        = "allow_s3_bucket_ssm"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject",
        ]
        Effect   = "Allow"
        Resource = [
          "arn:aws:s3:::iti-ssm-bucket", 
          "arn:aws:s3:::iti-ssm-bucket/*"
        ]
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_ssm_policy" {
  role       = aws_iam_role.ec2_ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "attach_s3_policy" {
  role       = aws_iam_role.ec2_ssm.name
  policy_arn = aws_iam_policy.s3_bucket.arn
}



resource "aws_iam_instance_profile" "ssm_ec2_profile" {
  name = "ec2_profile"
  role = aws_iam_role.ec2_ssm.id
}
