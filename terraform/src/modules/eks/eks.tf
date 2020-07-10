resource "aws_eks_cluster" "app" {
  name     = "${var.base_name}-eks"
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids = [var.subnet1.id, var.subnet2.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.cluster-AmazonEKSServicePolicy,
    aws_cloudwatch_log_group.test_eks
  ]
}

# cloudwatch
resource "aws_cloudwatch_log_group" "test_eks" {
  name              = "/aws/eks/${var.base_name}_eks/cluster"
  retention_in_days = 5
}

# security group
resource "aws_security_group" "eks_master" {
  name   = "${var.base_name}_eks"
  vpc_id = var.vpc_main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "for_eks_node"
  }
}

# node group
resource "aws_eks_node_group" "node" {
  cluster_name    = aws_eks_cluster.app.name
  node_group_name = "${var.base_name}_node_group"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = [var.subnet1.id, var.subnet2.id]

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  labels = {
    engine = "ec2"
  }

  instance_types = ["t3a.small"]
  disk_size      = 20
}
