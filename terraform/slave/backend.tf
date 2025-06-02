terraform {
  backend "s3" {
    bucket = "aws-3-tier-iti"
    key = "iti/jenkins-ssm-slave"
    region = "us-east-1"
  }
}