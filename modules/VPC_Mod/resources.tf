###### VPC
resource "aws_vpc" "main" {
  cidr_block  = var.ipblock
  tags        = {
   Name       = "var.vpc_name"
 }
}

###### Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags    = {
    Name  = "var.vpc_name-Internet_Gateway"
  }
}

##### Public Subnets
resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = cidrsubnet(var.ipblock, 5, 2)

  tags        = {
    Name      = "CPFpublic-1a"
  }
}

#Pub1b
resource "aws_subnet" "public2" {
  vpc_id      = aws_vpc.main.id
  cidr_block  = cidrsubnet(var.ipblock, 5, 3)

  tags        = {
    Name      = "CPFpublic-1b"
  }
}

#Pub1c
resource "aws_subnet" "public3" {
  vpc_id      = aws_vpc.main.id
  cidr_block  = cidrsubnet(var.ipblock, 5, 4)

  tags        = {
    Name      = "CPFpublic-1c"
  }
}

##### Privet Subnets
resource "aws_subnet" "privet1" {
  vpc_id      = aws_vpc.main.id
  cidr_block  = cidrsubnet(var.ipblock, 5, 5)

  tags        = {
    Name      = "CPFprivet-1a"
  }
}

#Priv1b
resource "aws_subnet" "privet2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = cidrsubnet(var.ipblock, 5, 6)

  tags       = {
    Name     = "CPFprivet-1b"
  }
}

#Priv1c
resource "aws_subnet" "Privet3" {
  vpc_id      = aws_vpc.main.id
  cidr_block  = cidrsubnet(var.ipblock, 5, 7)

  tags        = {
    Name      = "CPFprivet-1c"
  }
}


##### public router table
resource "aws_route_table" "public-router" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
}
    tags = {
      Name = "Public Route Table CPF"
    }
 }


##### Associate route table
  resource "aws_route_table_association" "public-router" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public-router.id
}

##### Elastic IP
 resource "aws_eip" "eip" {
   depends_on = [aws_internet_gateway.gw]
   vpc      = true
 }


##### Nat Gateway
 resource "aws_nat_gateway" "nat" {
 allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "NAT Gateway CPF"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}


##### Privet router table
resource "aws_route_table" "privet-router" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
}
    tags = {
      Name = "Privet Route Table CPF"
    }
 }



 #### Associate Privet route table
   resource "aws_route_table_association" "APR" {
   subnet_id      = aws_subnet.privet1.id
   route_table_id = aws_route_table.privet-router.id
 }
