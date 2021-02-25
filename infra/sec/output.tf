output "sg_app" {
  value = "${aws_security_group.myproject-appSG.id}"
}
output "sg_lb" {
  value = "${aws_security_group.public-sg.id}"
}
output "sg_jump" {
  value = "${aws_security_group.jump-sg.id}"
}
