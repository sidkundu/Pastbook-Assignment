output "cluster_endpoint" {
  value = "${aws_eks_cluster.myproject.endpoint}"
}

output "eks_cert_authority" {
  value = "${aws_eks_cluster.myproject.certificate_authority}"
}
output "eks-worker-assume-role" {
 value = "${aws_iam_role.eks-worker-assume-role.arn}"
}
