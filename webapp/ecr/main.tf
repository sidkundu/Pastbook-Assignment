/* Create ECR repository */

resource "aws_ecr_repository" "myproject" {
  name = "myproject"

  }

resource "aws_ecr_repository" "jenkins" {
  name = "jenkins"

  provisioner "local-exec" {
    command = "${path.module}/build.sh ${var.jenkinsdockerfile_folder} ${aws_ecr_repository.jenkins.repository_url}:${var.docker_image_tag} ${var.region}"
  }

  }

resource "aws_ecr_repository" "dind" {
  name = "dind"

  provisioner "local-exec" {
    command = "${path.module}/build.sh ${var.dinddockerfile_folder} ${aws_ecr_repository.dind.repository_url}:${var.docker_image_tag} ${var.region}"
  }

  }



