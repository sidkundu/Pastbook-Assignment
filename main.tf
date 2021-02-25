#### VARIABLES
variable "profile" {
  default = "default"
}
variable "region" {
  default = "eu-central-1"
}
variable "repository_name" {
  default = "myproject/jenkins"
}
variable "cluster-name" {
  default = "myproject"
}
variable "docker_image_tag" {
  default = "latest"
}
variable "dinddockerfile_folder" {
  default = "dind/"
}
variable "jenkinsdockerfile_folder" {
  default = "./"
}

variable "db_password" {
  default = "pastbookaws"
}

#### CALL MDOULES
module "core_infra" {
  source = "./infra"
}

module "db" {
  source      = "./webapp/db"
  sg_app      = "${module.core_infra.sg_app}"
  sn_privdb1  = "${module.core_infra.sn_privdb1}"
  sn_privdb2  = "${module.core_infra.sn_privdb2}"
  sn_privdb3  = "${module.core_infra.sn_privdb3}"
  vpc         = "${module.core_infra.vpc}"
  db_password = "${var.db_password}"
}

module "s3" {
  source = "./webapp/s3"
}

module "eks" {
  source          = "./webapp/eks"
  profile         = "${var.profile}"
  region          = "${var.region}"
  cluster-name    = "${var.cluster-name}"
  repository_name = "myproject/test-project"
  # pass web security group and public networks
  sg_app      = "${module.core_infra.sg_app}"
  sn_privapp1 = "${module.core_infra.sn_privapp1}"
  sn_privapp2 = "${module.core_infra.sn_privapp2}"
  sn_privapp3 = "${module.core_infra.sn_privapp3}"
  sn_pub1     = "${module.core_infra.sn_pub1}"
  sn_pub2     = "${module.core_infra.sn_pub2}"
  sn_pub3     = "${module.core_infra.sn_pub3}"
  sg_lb       = "${module.core_infra.sg_lb}"
  vpc         = "${module.core_infra.vpc}"

}

module "ecr" {
  source            = "./webapp/ecr"
  region            = "${var.region}"
  docker_image_tag  = "${var.docker_image_tag}"
  jenkinsdockerfile_folder = "${var.jenkinsdockerfile_folder}"
  dinddockerfile_folder = "${var.dinddockerfile_folder}"
}

  
resource "null_resource" "setupcluster" {
  provisioner "local-exec" {
    command = "./webapp/eks/files/setupcluster.sh ${var.cluster-name} ${module.eks.cluster_endpoint} ${module.eks.eks_cert_authority[0].data} ${module.eks.eks-worker-assume-role}"
  }
depends_on = [module.eks,module.ecr]
}
