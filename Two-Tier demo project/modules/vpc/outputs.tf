output "vpc_id" {
  value = aws_vpc.main.id
}

output "alb_subnets" {
  value = [for s in aws_subnet.public-subnets : s.id]
}

output "instance_subnets" {
  value = [for s in aws_subnet.private-subnets : s.id]
}