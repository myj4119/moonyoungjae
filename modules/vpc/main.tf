#================== VPC 생성 ===================
resource "aws_vpc" "main_vpc" {
  cidr_block = var.main_vpc_cidr

  tags = {
    Name = "${var.env}-main_infra_vpc"
  }
}

resource "aws_vpc" "service_vpc" {
  cidr_block = var.service_vpc_cidr

  tags = {
    Name = "${var.env}-service_infra_vpc "
  }
}

#================== Subnet 생성 ===================
resource "aws_subnet" "public_subnet_1" {
  count             = var.env == "prd" ? 0 : 1
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.default_public_subnet_1
  availability_zone = var.lo_a

  tags = {
    Name = "${var.env}-public_subnet_1"
  }
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.default_private_subnet_1
  availability_zone = var.lo_a

  tags = {
    Name = "${var.env}-private_subnet_1"
  }
}

resource "aws_subnet" "EKS_public_subnet" {
  count             = length(var.EKS_public_subnet) # public_subnets 변수의 길이만큼 서브넷 생성
  vpc_id            = aws_vpc.service_vpc.id
  cidr_block        = var.EKS_public_subnet[count.index].cidr_block
  availability_zone = var.EKS_public_subnet[count.index].availability_zone

  tags = {
    Name = "${var.env}-EKS_public_subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "EKS_private_subnet" {
  count             = length(var.EKS_private_subnet)
  vpc_id            = aws_vpc.service_vpc.id
  cidr_block        = var.EKS_private_subnet[count.index].cidr_block
  availability_zone = var.EKS_private_subnet[count.index].availability_zone

  tags = {
    Name = "${var.env}-EKS_private_subnet-${count.index + 1}"
  }
}


#================== igw 생성 ===================
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "${var.env}-igw"
  }
}

resource "aws_internet_gateway" "EKS_igw" {
  vpc_id = aws_vpc.service_vpc.id

  tags = {
    Name = "${var.env}-EKS_igw"
  }
}


#================== natgw 생성 ===================
resource "aws_eip" "EKS_nat_eip" {
  instance = null
  tags = {
    Name = "EKS_eip"
  }
}


resource "aws_nat_gateway" "EKS_nat_gw" {
  allocation_id = aws_eip.EKS_nat_eip.id
  subnet_id     = aws_subnet.EKS_public_subnet[0].id

  tags = {
    Name = "EKS NAT gw"
  }

  depends_on = [aws_internet_gateway.main_igw]
}

#================== Routing Table 생성 ===================
resource "aws_route_table" "main_rt" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "${var.env}-main_rt"
  }
}

resource "aws_route_table_association" "main_rt_asso" {
  subnet_id      = aws_subnet.public_subnet_1[0].id
  route_table_id = aws_route_table.main_rt.id
}

resource "aws_route" "main_pub_igw_route" {
  route_table_id         = aws_route_table.main_rt.id
  destination_cidr_block = "0.0.0.0/0"

  gateway_id = aws_internet_gateway.main_igw.id
}



resource "aws_route_table" "EKS_pub_rt" {
  vpc_id = aws_vpc.service_vpc.id

  tags = {
    Name = "${var.env}-EKS_pub_rt"
  }
}

resource "aws_route_table_association" "EKS_pub_rt_asso" {
  count          = length(aws_subnet.EKS_public_subnet)
  subnet_id      = aws_subnet.EKS_public_subnet[count.index].id
  route_table_id = aws_route_table.EKS_pub_rt.id
}

resource "aws_route" "EKS_pub_igw_route" {
  route_table_id         = aws_route_table.EKS_pub_rt.id
  destination_cidr_block = "0.0.0.0/0"

  gateway_id = aws_internet_gateway.EKS_igw.id
}




resource "aws_route_table" "EKS_pri_rt" {
  vpc_id = aws_vpc.service_vpc.id

  tags = {
    Name = "${var.env}-EKS_pri_rt"
  }
}

resource "aws_route_table_association" "EKS_pri_rt_asso" {
  count          = length(aws_subnet.EKS_private_subnet)
  subnet_id      = aws_subnet.EKS_private_subnet[count.index].id
  route_table_id = aws_route_table.EKS_pri_rt.id
}

resource "aws_route" "EKS_pri_natgw_route" {
  route_table_id         = aws_route_table.EKS_pri_rt.id
  destination_cidr_block = "0.0.0.0/0"

  nat_gateway_id = aws_nat_gateway.EKS_nat_gw.id
}
