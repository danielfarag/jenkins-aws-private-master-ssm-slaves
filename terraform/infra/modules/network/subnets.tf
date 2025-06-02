resource "aws_subnet" "public"{
    vpc_id = aws_vpc.vpc.id
    availability_zone = var.availability_zone
    cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 8, 0)
    tags = {
      Name = "Public Subnet (Jenkins)"
    }
}


resource "aws_subnet" "private"{
    vpc_id = aws_vpc.vpc.id
    availability_zone = var.availability_zone
    cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 8, 1)
    tags = {
      Name = "Private Subnet (Jenkins)"
    }
}