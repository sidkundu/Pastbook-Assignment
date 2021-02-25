output "mysqldb_params" {
  value = "${aws_db_parameter_group.mydbparams.id}"
}

output "mysqldb_subnet_group" {
  value = "${aws_db_subnet_group.mydbsubnetgroup.id}"
}

output "mysqldb_sg" {
  value = "${aws_security_group.mydb-sg.id}"
}

output "mysqldb_instance" {
  value = "${aws_db_instance.mysqldb.id}"
}
