
output "vpc" {
  value = aws_vpc.vpc
}

output "public_subnet" {
  value = aws_subnet.public
}

output "private_subnet" {
  value = aws_subnet.private
}

output "nat" {
  value = aws_nat_gateway.nat
}