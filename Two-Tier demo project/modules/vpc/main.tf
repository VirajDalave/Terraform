resource "aws_vpc" "vpc-1" {
  cidr_block = var.cidr_block

  enable_dns_hostnames = true
  enable_dns_support = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc-1.id
}


resource "aws_eip" "nat-eip" {
  count = length(var.cidr_blocks_pub_sub)
  domain = "vpc"
  depends_on = [ aws_internet_gateway.igw ]
}

resource "aws_nat_gateway" "ngw" {
  count = length(var.cidr_blocks_pub_sub)
  subnet_id = aws_subnet.public-subnet-1[count.index].id
  allocation_id = aws_eip.nat-eip[count.index].id

  depends_on = [ aws_subnet.public-subnet-1, aws_subnet.private-subnet-1 , aws_internet_gateway.igw]
}


resource "aws_subnet" "public-subnet-1" {
    vpc_id = aws_vpc.vpc-1.id
    count = length(var.cidr_blocks_pub_sub)
    cidr_block = var.cidr_blocks_pub_sub[count.index]
    map_public_ip_on_launch = true

    availability_zone = var.availability_zones[count.index]
}

resource "aws_route_table" "pub-rt" {
  vpc_id = aws_vpc.vpc-1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "pub-rta" {
  count = length(var.cidr_blocks_pub_sub)
  route_table_id = aws_route_table.pub-rt.id
  subnet_id = aws_subnet.public-subnet-1[count.index].id

}

resource "aws_subnet" "private-subnet-1" {
    vpc_id = aws_vpc.vpc-1.id
    count = length(var.cidr_blocks_priv_sub)
    cidr_block = var.cidr_blocks_priv_sub[count.index]
    
    availability_zone = "ap-south-1b"
}

resource "aws_route_table" "priv-rt" {
  vpc_id = aws_vpc.vpc-1.id

  count = length(var.cidr_blocks_priv_sub)
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngw[count.index].id
  }
}

resource "aws_route_table_association" "priv-rta" {
  count = length(var.cidr_blocks_priv_sub)
  route_table_id = aws_route_table.priv-rt[count.index].id
  subnet_id = aws_subnet.private-subnet-1[count.index].id

}