output "vpc" {
  value = "${aws_vpc.myproject-main.id}"
}
output "sn_pub1" {
  value = "${aws_subnet.myproject-public1.id}"
}
output "sn_pub2" {
  value = "${aws_subnet.myproject-public2.id}"
}
output "sn_pub3" {
  value = "${aws_subnet.myproject-public3.id}"
}
output "sn_privapp1" {
  value = "${aws_subnet.myproject-private1-app.id}"
}
output "sn_privapp2" {
  value = "${aws_subnet.myproject-private2-app.id}"
}
output "sn_privapp3" {
  value = "${aws_subnet.myproject-private3-app.id}"
}
output "sn_privdb1" {
  value = "${aws_subnet.myproject-private1-db.id}"
}
output "sn_privdb2" {
  value = "${aws_subnet.myproject-private2-db.id}"
}
output "sn_privdb3" {
  value = "${aws_subnet.myproject-private3-db.id}"
}
