# aws_vpc
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "${var.base_name}-network"
  }
}

# aws_internet_gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = var.base_name
  }
}

# aws_route_table
resource "aws_route_table" "rt_public_a" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.base_name}-table-pub-a"
  }
}

resource "aws_route_table" "rt_public_c" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.base_name}-table-pub-c"
  }
}

# aws_route_table_association
resource "aws_route_table_association" "rta_public_a" {
  route_table_id = aws_route_table.rt_public_a.id
  subnet_id      = aws_subnet.public_a.id
}

resource "aws_route_table_association" "rta_public_c" {
  route_table_id = aws_route_table.rt_public_c.id
  subnet_id      = aws_subnet.public_c.id
}

# aws_route
resource "aws_route" "route_public_a" {
  route_table_id         = aws_route_table.rt_public_a.id
  gateway_id             = aws_internet_gateway.igw.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route" "route_public_c" {
  route_table_id         = aws_route_table.rt_public_c.id
  gateway_id             = aws_internet_gateway.igw.id
  destination_cidr_block = "0.0.0.0/0"
}

# subnet
resource "aws_subnet" "public_a" {
  availability_zone       = "${data.aws_region.current.name}a"
  cidr_block              = "10.0.1.0/24"
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.base_name}-subnet-pub-a"
    "kubernetes.io/cluster/${var.base_name}-eks" = "shared"
    KubernetesCluster = "${var.base_name}-eks"
    "kubernetes.io/role/elb" = 1
  }
}

resource "aws_subnet" "public_c" {
  availability_zone       = "${data.aws_region.current.name}c"
  cidr_block              = "10.0.2.0/24"
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.base_name}-subnet-pub-c"
    "kubernetes.io/cluster/${var.base_name}-eks" = "shared"
    KubernetesCluster = "${var.base_name}-eks"
    "kubernetes.io/role/elb" = 1
  }
}
