set -e

build_folder=$1
aws_ecr_repository_url_with_tag=$2
aws_region=$3

# Allow overriding the aws region from system
if [ "$aws_region" != "" ]; then
	  aws_extra_flags="--region $aws_region"
  else
	    aws_extra_flags=""
    fi

    # Check that aws is installed
    which aws > /dev/null || { echo 'ERROR: aws-cli is not installed' ; exit 1; }

    # Check that docker is installed and running
    which docker > /dev/null && docker ps > /dev/null || { echo 'ERROR: docker is not running' ; exit 1; }

    echo "aws ecr get-login-password $aws_extra_flags | docker login -u AWS --password-stdin $aws_ecr_repository_url_with_tag"   
    # Connect into aws
    aws ecr get-login-password $aws_extra_flags | docker login -u AWS --password-stdin $aws_ecr_repository_url_with_tag

    # Some Useful Debug
    echo "Building $aws_ecr_repository_url_with_tag from $build_folder"

    # Build image
    docker build -t $aws_ecr_repository_url_with_tag $build_folder

    # Push image
    docker push $aws_ecr_repository_url_with_tag