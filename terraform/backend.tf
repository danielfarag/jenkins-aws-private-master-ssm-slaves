terraform {
  backend "s3" {
    bucket = "aws-3-tier-iti"
    key = "iti/jenkins-ssm"
    region = "us-east-1"
  }
}