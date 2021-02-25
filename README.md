
***
As per the assignment a frontend nodejs application was required. An S2 bucket to save the pictures and a relation DB to store the metadata. 
## This Solution satisfied below requirements:

***
1. Terraform to provision the EKS with EC2 worker nodes
2. Helm packages to deploy jenkins and application
3. Jenkinsfile to build the nodejs application and create docker image and save it to ecr
4. Helm package to deploy build created by jenkins in EKS cluster

## Solution Overview:

This solution has 2 different modules : **Infra/net,sec** and **webapp/eks,ecr,db,s3**

1. **Infra/net,sec** - These modules will spin up entire network infrastructure required to run required applications as below:

>      - VPC with cidr : 10.0.0.0/16
>      - Seperate private subnets in each availability zone(a,b,c) seperately to use by application and database.
>      - Public subnets in each availabilityzone(a,b,c) for Loadbalancers.
>      - Internet Gateway to enable the connectivity with Internet.
>      - 1 Elastic IP per Nat gateway in each availability zones to enable outbound internet connectivity from private subnets
>      Route table :
>      - One route table to associate public subnets with internet gateway to enable internet connectivity from public subnet
>      - One route table to associate each private subnets with their corresponding NAT gateway to enable internet connectivity from private instances without being accessible by public domain.
>      - 3 generic Security groups as below:  
>           - app security group : For private instances.
>           - LB/Public security group: To access the requests from internet and forward it to webapp server
>           - JumpBox Security group: To allow ssh request from internet.

2. **MAIN** : Main module(main.tf) is declaring default values like clustername,profile etc. Once below mentioned module completes successfully, 
              It prepares the environent to make the deployments in EKS cluster by running setupcluster.sh (webapp/eks/files)
	 
3. **S3**: This module will spin up below:
- Create AWS S3 bucket in the default region with encryption

3. **MYSQLDB**: This module will spin up below:
- Create DB parameter group for the MYSQL DB
- Create a Security Group for the DB to be accessed only by the private subnet application
- Create a SUbnet Group for the DB
- Create a MYSQL DB instance

3. **EKS**: This module will spin up below:
- Create EKS cluster with 3 workers nodes of type t2-medium
- Create Nodegroup
- Create IAM roles and Security groups specific to EKS cluster to enable the communication

4. **ECR**: This module will setup ECR reposiroties as below:
- Provision 3 repository. i.e. myproject(sample nodejs app), jenkins, dind(for docker-in-docker)
- Create jenkins image by running dockerfile in main and dind directory and push it to ECR by running script

***
## How to setup/Run


***Assumptions**:*
- EKS Cluster provision on new AWS infrastructure
- Worker Nodes must be EC2
- Helm chart to deploy jenkins and applications
- Jenkinsfile to create pipeline in newly created jenkins on EKS
- Setup is running CentOS 7
- Used Nodejs frontend app as mentioned in assignment

***Pre-requisites:***

1. aws cli and profile configured with proper rights and user has access to create all resources in AWS.
2. terraform installed on the system.
3. helm
4. kubectl
5. aws-iam-authenticato

If you dont have these then please run **setup.sh** if the OS is centos7 it will install required tools.

**Steps to execute**

- Clone the project
- Change the value of AWS account number in the following places
  1.) JenkinsFile
  2.) values.yaml for Jenkins
  3.) values.yaml for Jenkins

- Load environment variable for aws region:
- **export AWS_DEFAULT_REGION=eu-central-1** ( or you can change if you want)

-  **terraform init** : To install aws provider.

-  **terraform plan** : This will show the plan which terraform is going to execute.It will pick up some default variable declared in main.tf file you can override them at runtime as well.

5. **terraform apply** : Enter yes.it takes around 15-18 mins for finish:

>  Entire infrastructure in AWS to setup EKS
>  Cluster endpoint
>  Deploys the jenkins on EKS and print alb dns name as well on the screen check "endpoint ready"

You can also check the details by running kubectl get all

## Validation:
**
- Copy the alb dns name from above step and paste it on browser: It will show you the jenkins page.Please enter the credentials as **admin:password** to login
- Create multibranch pipeline, Add connection as Github, repo url as source control.
- Exceute the pipeline, it will build the sample "Welcome to PastBook" image (nodejs) and place it in myproject ecr repo in aws and then deploy it to EKS and give you alb name to access.Wait for couple of minutes for app to load.



**Points to be note/Improvements:**

1. Terraform apply take some time to create the cluster.
2. We can add more security around this solution by adding certificates on alb and keep the connection secure.
3. We can also create route53 record to point to alb to have more meaningful name.
4. We can also add more security in jenkinsfile to  add credentials as secret or to add some test before the deployment.To keep it simple i have not added any test for now.
5. Currently jenkins user password is in plain text in values file but we can also encrypt it by encoding and decoding it using base64 value.
6. Used Security group as seperate module as those are only generic SG else other security are part of the module itself.
7. Monitoring to be set up using default prometheus set up
8. Data structure can be improved given some extra time around the design

**CleanUp**
- Please remove all the deployment and services: kubectl delete deployment/services <name> or helm uninstall jenkins-k8s/myproject-sample (give helm/app or helm/jenkins as path)
- terraform destroy
