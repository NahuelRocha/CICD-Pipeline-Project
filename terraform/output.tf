output "vpc_id" {
  value = aws_vpc.pipeline_vpc.id
}

output "subnet_ids" {
  value = aws_subnet.pipeline_subnet[*].id
}

output "cluster_name" {
  value = aws_eks_cluster.pipeline.name
}

output "role_arn" {
  value = aws_iam_role.pipeline_cluster_role.arn
}