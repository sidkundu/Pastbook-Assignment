# Net module output
output "vpc" {
  value = "${module.network.vpc}"
}
output "sn_pub1" {
  value = "${module.network.sn_pub1}"
}
output "sn_pub2" {
  value = "${module.network.sn_pub2}"
}
output "sn_pub3" {
  value = "${module.network.sn_pub3}"
}
output "sn_privapp1" {
  value = "${module.network.sn_privapp1}"
}
output "sn_privapp2" {
  value = "${module.network.sn_privapp2}"
}
output "sn_privapp3" {
  value = "${module.network.sn_privapp3}"
}
output "sn_privdb1" {
  value = "${module.network.sn_privdb1}"
}
output "sn_privdb2" {
  value = "${module.network.sn_privdb2}"
}
output "sn_privdb3" {
  value = "${module.network.sn_privdb3}"
}
# Sec module output
output "sg_app" {
  value = "${module.security.sg_app}"
}
output "sg_lb" {
  value = "${module.security.sg_lb}"
}
