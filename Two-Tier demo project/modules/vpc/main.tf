resource "aws_vpc" "main" {
  cidr_block = var.cidr_block

  enable_dns_hostnames = true
  enable_dns_support = true
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_subnet" "public-subnets" {
    vpc_id = aws_vpc.main.id
    count = length(var.cidr_blocks_pub_sub)
    cidr_block = var.cidr_blocks_pub_sub[count.index]
    map_public_ip_on_launch = true

    availability_zone = data.aws_availability_zones.available.names[count.index]
}


resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public" {
  count = length(var.cidr_blocks_pub_sub)
  route_table_id = aws_route_table.public.id
  subnet_id = aws_subnet.public-subnets[count.index].id

}


resource "aws_eip" "nat-eip" {
  count = length(var.cidr_blocks_pub_sub)
  domain = "vpc"
  depends_on = [ aws_internet_gateway.igw ]
}

resource "aws_nat_gateway" "ngw" {
  count = length(var.cidr_blocks_pub_sub)
  subnet_id = aws_subnet.public-subnets[count.index].id
  allocation_id = aws_eip.nat-eip[count.index].id

  depends_on = [ aws_subnet.public-subnets, aws_subnet.private-subnets , aws_internet_gateway.igw]
}



resource "aws_subnet" "private-subnets" {
    vpc_id = aws_vpc.main.id
    count = length(var.cidr_blocks_priv_sub)
    cidr_block = var.cidr_blocks_priv_sub[count.index]
    
    availability_zone = data.aws_availability_zones.available.names[count.index]
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  count = length(var.cidr_blocks_priv_sub)
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngw[count.index].id
  }
}

resource "aws_route_table_association" "private" {
  count = length(var.cidr_blocks_priv_sub)
  route_table_id = aws_route_table.private[count.index].id
  subnet_id = aws_subnet.private-subnets[count.index].id
}