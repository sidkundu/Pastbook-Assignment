
/*==== Public Security group ====*/ 

resource "aws_security_group" "public-sg" {
  name        = "myproject-public-ip"
  description = "Allow traffic from internet to LB"
  vpc_id      = "${var.vpc_id}"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    self            = false

  }
  
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    self            = false

  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name = "myproject-LB"
  }
}

/*==== Jump Security Group ====*/ 

resource "aws_security_group" "jump-sg" {
  name        = "myproject-jump-sg"
  description = "Allow ssh from internet to Jumpbox"
  vpc_id      = "${var.vpc_id}"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    self            = false

  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "myproject-jump-sg"
  }
}


/*==== App Security group ====*/ 

resource "aws_security_group" "myproject-appSG" {
  name        = "webserver-app"
  description = "Allow traffic from Webservers"
  vpc_id      = "${var.vpc_id}"
  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    security_groups = ["${aws_security_group.public-sg.id}"]

  }
    ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]

  }
  tags = {
    Name = "myproject-app-sg"
  }
}

