#================== VPC 생성 ===================
resource "aws_vpc" "main_vpc" {
  cidr_block = var.main_vpc_cidr

  tags = {
    Name = "${var.env}-main_infra_vpc"
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


#================== igw 생성 ===================
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "${var.env}-igw"
  }
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
