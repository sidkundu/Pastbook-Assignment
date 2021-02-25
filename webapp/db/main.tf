resource "aws_db_parameter_group" "mydbparams" {
  name   = "mydbparams"
  family = "mysql8.0"
}

resource "aws_db_subnet_group" "mydbsubnetgroup" {
  name       = "mydbsubnetgroup"
  subnet_ids = ["${var.sn_privdb1}", "${var.sn_privdb2}", "${var.sn_privdb3}"]

  tags = {
    Name = "mydbsubnetgroup"
  }
}

resource "aws_security_group" "mydb-sg" {
  name        = "mydb-sg"
  description = "Allow traffic from the private application"
  vpc_id      = "${var.vpc}"

  ingress {
    description = "TLS from VPC"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = ["${var.sg_app}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "mydb-sg"
  }
}


resource "aws_db_instance" "mysqldb" {
  allocated_storage      = 100
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t2.small"
  name                   = "mydb"
  username               = "root"
  password               = "${var.db_password}"
  db_subnet_group_name   = "${aws_db_subnet_group.mydbsubnetgroup.id}"
  parameter_group_name   = "${aws_db_parameter_group.mydbparams.id}"
  multi_az               = "true"
  vpc_security_group_ids = ["${aws_security_group.mydb-sg.id}"]
  skip_final_snapshot    = true

   tags = {
    Name = "mysqldb"
  }
}
