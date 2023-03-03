resource "aws_vpc" "vpc" {
  cidr_block           = "10.20.0.0/16"
  enable_dns_hostnames = true
  tags = {
   Name = "VPC-${local.project_name}"
 }
}

resource "aws_internet_gateway" "internet_gateway" {
 vpc_id = aws_vpc.vpc.id
 tags = {
   Name = "InternetGateway-${local.project_name}"
 }
}

resource "aws_subnet" "public_subnet" {
    count = length(data.aws_availability_zones.available.names)
    vpc_id            = aws_vpc.vpc.id
    cidr_block = "10.20.${10+count.index}.0/24"
    availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
    map_public_ip_on_launch = true
    
    tags = {
        Name = "PublicSubnet-${local.project_name}-${count.index}"
    }
}

resource "aws_subnet" "private_subnet" {
    count = length(data.aws_availability_zones.available.names)
    vpc_id            = aws_vpc.vpc.id
    cidr_block = "10.20.${20+count.index}.0/24"
    availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
    map_public_ip_on_launch = false
    
    tags = {
        Name = "PrivateSubnet-${local.project_name}-${count.index}"
    }
}

resource "aws_security_group" "server_security_group" {
  count = 2
  name        = "security_group_${count.index}"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    to_port     = "0"
  }

  tags = {
    "Name" = "ServerSecurityGroup-${count.index}-${local.project_name}"
  }
}

resource "aws_instance" "server_amazon_linux" {
    count = 2
    ami = var.amis[data.aws_region.current.name]
    instance_type = "t2.micro"
    subnet_id = aws_subnet.private_subnet[count.index].id
    vpc_security_group_ids = [aws_security_group.server_security_group[count.index].id]

    tags = {
        Name = "Server-AmzLinux-${count.index}-${local.project_name}"
        }
}

resource "aws_security_group" "load_balancer_security_group" {
  name        = "terraform_alb_secuload_balancer_security_grouprity_group"
  vpc_id      = "${aws_vpc.vpc.id}"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "LBSecurityGroup-${local.project_name}"
  }
}

resource "aws_lb" "load_balancer" {
  name               = "LoadBalancer-${local.project_name}"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.private_subnet[0].id, aws_subnet.private_subnet[1].id]
  security_groups    = [aws_security_group.load_balancer_security_group.id]

  tags = {
    "Name" = "LoadBalancer-${local.project_name}"
  }
}

resource "aws_security_group" "rds_security_group" {
  name        = "rds_security_group"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Name" = "RDSSecurityGroup-${local.project_name}"
  }
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds_subnet_group"
  subnet_ids = [aws_subnet.private_subnet[0].id, aws_subnet.private_subnet[1].id]

  tags = {
    Name = "DBSunbnetGroup-${local.project_name}"
  }
}

resource "aws_db_instance" "rds_instance" {
  identifier             = "rds-instance"
  db_name                = "rds"
  instance_class         = "db.t2.micro"
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "12"
  skip_final_snapshot    = true
  publicly_accessible    = true
  vpc_security_group_ids = [aws_security_group.rds_security_group.id]
  db_subnet_group_name    = "${aws_db_subnet_group.rds_subnet_group.name}"
  username               = "iacTestUser"
  password               = "userPassTest"

  tags = {
    "Name" = "RDS-${local.project_name}"
	  }
}