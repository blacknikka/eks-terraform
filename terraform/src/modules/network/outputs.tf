output "vpc_main" {
  value = aws_vpc.main
}

output "subnet_a" {
  value = aws_subnet.public_a
}

output "subnet_c" {
  value = aws_subnet.public_c
}
