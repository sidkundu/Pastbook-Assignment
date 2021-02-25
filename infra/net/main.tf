/*==== VPC ====*/

resource "aws_vpc" "myproject-main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = false
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags = {
    Name = "myproject-vpc"
  }
}

data "aws_availability_zones" "available" {}

/*==== Public Subets ====*/ 

resource "aws_subnet" "myproject-public1" {
  vpc_id                  = "${aws_vpc.myproject-main.id}"
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"
  map_public_ip_on_launch = true

  tags = {
    Name = "myproject-public1"
  }
}

resource "aws_subnet" "myproject-public2" {
  vpc_id                  = "${aws_vpc.myproject-main.id}"
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"
  map_public_ip_on_launch = true

  tags = {
    Name = "myproject-public2"
  }
}

resource "aws_subnet" "myproject-public3" {
  vpc_id                  = "${aws_vpc.myproject-main.id}"
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "${data.aws_availability_zones.available.names[2]}"
  map_public_ip_on_launch = true

  tags = {
    Name = "myproject-public3"
  }
}

/*==== Private Subnets ====*/ 

resource "aws_subnet" "myproject-private1-app" {
  vpc_id                  = "${aws_vpc.myproject-main.id}"
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"
  map_public_ip_on_launch = true

  tags = {
    Name = "myproject-private1-app"
  }
}

resource "aws_subnet" "myproject-private2-app" {
  vpc_id                  = "${aws_vpc.myproject-main.id}"
  cidr_block              = "10.0.5.0/24"
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"
  map_public_ip_on_launch = true

  tags = {
    Name = "myproject-private2-app"
  }
}

resource "aws_subnet" "myproject-private3-app" {
  vpc_id                  = "${aws_vpc.myproject-main.id}"
  cidr_block              = "10.0.6.0/24"
  availability_zone       = "${data.aws_availability_zones.available.names[2]}"
  map_public_ip_on_launch = true

  tags = {
    Name = "myproject-private3-app"
  }
}

resource "aws_subnet" "myproject-private1-db" {
  vpc_id                  = "${aws_vpc.myproject-main.id}"
  cidr_block              = "10.0.7.0/24"
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"
  map_public_ip_on_launch = true

  tags = {
    Name = "myproject-private1-db"
  }
}

resource "aws_subnet" "myproject-private2-db" {
  vpc_id                  = "${aws_vpc.myproject-main.id}"
  cidr_block              = "10.0.8.0/24"
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"
  map_public_ip_on_launch = true

  tags = {
    Name = "myproject-private2-db"
  }
}

resource "aws_subnet" "myproject-private3-db" {
  vpc_id                  = "${aws_vpc.myproject-main.id}"
  cidr_block              = "10.0.9.0/24"
  availability_zone       = "${data.aws_availability_zones.available.names[2]}"
  map_public_ip_on_launch = true

  tags = {
    Name = "myproject-private3-db"
  }
}

/*==== Internet Gateway ====*/ 

resource "aws_internet_gateway" "myproject-igw" {
  vpc_id = "${aws_vpc.myproject-main.id}"

  tags = {
    Name = "myproject-igw"
  }
}

/*==== Route Tables ====*/ 

resource "aws_route_table" "myproject-rt" {
  vpc_id = "${aws_vpc.myproject-main.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.myproject-igw.id}"
  }

  tags = {
    Name = "myproject-rtable"
  }
}

resource "aws_route_table_association" "myproject-public1" {
  subnet_id      = "${aws_subnet.myproject-public1.id}"
  route_table_id = "${aws_route_table.myproject-rt.id}"
}

resource "aws_route_table_association" "myproject-public2" {
  subnet_id      = "${aws_subnet.myproject-public2.id}"
  route_table_id = "${aws_route_table.myproject-rt.id}"
}

resource "aws_route_table_association" "myproject-public3" {
  subnet_id      = "${aws_subnet.myproject-public3.id}"
  route_table_id = "${aws_route_table.myproject-rt.id}"
}

/*==== Nat Gateway====*/ 

resource "aws_eip" "nat_gateway" {
  vpc = true
}

resource "aws_eip" "nat_gateway2" {
  vpc = true
}

resource "aws_eip" "nat_gateway3" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id     = "${aws_subnet.myproject-public1.id}"
  tags = {
    "Name" = "myproject-NatGateway-1"
  }
}

resource "aws_route_table" "myproject-instance" {
  vpc_id = "${aws_vpc.myproject-main.id}"
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
  tags = {
    "Name" = "myproject-nat1"
  }
}

resource "aws_route_table_association" "instance" {
  subnet_id      = "${aws_subnet.myproject-private1-app.id}"
  route_table_id = aws_route_table.myproject-instance.id
}

resource "aws_nat_gateway" "nat_gateway2" {
  allocation_id = aws_eip.nat_gateway2.id
  subnet_id     = "${aws_subnet.myproject-public2.id}"
  tags = {
    "Name" = "myproject-NatGateway2"
  }
}

resource "aws_route_table" "myproject-instance2" {
  vpc_id = "${aws_vpc.myproject-main.id}"
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat_gateway2.id}"
  }
  tags = {
    "Name" = "myproject-NatGateway2-rt"
  }
}

resource "aws_route_table_association" "instance2" {
  subnet_id      = "${aws_subnet.myproject-private2-app.id}"
  route_table_id = "${aws_route_table.myproject-instance2.id}"
}

resource "aws_nat_gateway" "nat_gateway3" {
  allocation_id = aws_eip.nat_gateway3.id
  subnet_id     = "${aws_subnet.myproject-public3.id}"
  tags = {
    "Name" = "myproject-NatGateway3"
  }
}


resource "aws_route_table" "myproject-instance3" {
  vpc_id = "${aws_vpc.myproject-main.id}"
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway3.id
  }
  tags = {
    "Name" = "myproject-NatGateway3-rt"
  }
}

resource "aws_route_table_association" "instance3" {
  subnet_id      = "${aws_subnet.myproject-private3-app.id}"
  route_table_id = "${aws_route_table.myproject-instance3.id}"
}
