output "vpc_id" {
  value = aws_vpc.pipeline_vpc.id
}

output "subnet_ids" {
  value = aws_subnet.pipeline_subnet[*].id
}