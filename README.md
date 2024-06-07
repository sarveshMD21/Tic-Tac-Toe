# unit 1 : About the Project

A simple tic-tac-toe application built using HTML, CSS and JS containerized using **docker** pushed to **ECR** repository and then deployed onto **AWS EKS** cluster.

Provisioning of all the resources on AWS for the project is automated using **terraform**.  Project involved understanding **docker** , **kubernetes** architecture and learning about various AWS services and other networking concepts. 

# unit 2 : AWS Resource Description 

Following is the Networking Resource Map for the project:

![](https://github.com/sarveshMD21/Tic-Tac-Toe/blob/main/ProjectImages/ProjectResourceMap.png)

As visible in the image the project consist of a VPC with 4 subnets within it .
2 private and 2 public . A pair of  public and private subnet is present withing two different availability zones.

Reason being EKS demands the worker nodes be present in two different availability zone.  The public subnet have a route to Internet Gateway and the private worker node which are provisioned in the private subnet are routed to NAT gateway

the private and public instance mapping is as follows

![Private Routing](https://github.com/sarveshMD21/Tic-Tac-Toe/blob/main/ProjectImages/PrivateNetworking.png)


![Public Routing](https://github.com/sarveshMD21/Tic-Tac-Toe/blob/main/ProjectImages/PublicNetworking.png)


#  unit 3 : K8s Files and ALB

For accessing the pods created via **Deployment.yml**  file  there is a service of type **NodePort** and an  Ingress resource of class **alb** . We need a AWS Load Balancer Controller in-order to watch for the ingress resource and accordingly provision a application load balancer for us according to the rules and target specified.

Following is the final resource map for the load balancer :

![](https://github.com/sarveshMD21/Tic-Tac-Toe/blob/main/ProjectImages/LoadBalancerMap.png)

The http request to the url will be internally routed as shown in the above image. 

# unit 4 : Setting up the project

 Prerequisites:
 

 - Install [docker](https://docs.docker.com/engine/install/) 
 - Install [terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) 
 - Install [kubectl](https://kubernetes.io/releases/download/)
 - Have a AWS , install AWS CLI and configure a CMD line user

For the final point you can get a bit of help [here](https://docs.aws.amazon.com/accounts/latest/reference/welcome-first-time-user.html) and [here](https://docs.aws.amazon.com/cli/).

Clone this project and first navigate to the tic-tac-toe directory. 

First we will need a ECR repository  in-order to push the image from where we will fetch it for our EKS cluster. Follow the below commands from cmd line for the same.

    ## authenticate first with AWS
    aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <aws_account_id>.dkr.ecr.<region>.amazonaws.com
    
    ## create a repository for the desired name you want
    aws ecr create-repository --repository-name <repository-name> --region <region>
    
    ## used for verifying if repo created or not
    aws ecr describe-repositories --region <region>    

Once the ECR repo is created we can build and push the docker image onto the ECR repo. Follow the below commands to publish images into ECR repo.

    ##  name and tag your image as you like
    docker tag <local-image>:<tag> <aws_account_id>.dkr.ecr.<region>.amazonaws.com/<repository-name>:<tag>
    ##  push the docker image onto the repo
    docker push <aws_account_id>.dkr.ecr.<region>.amazonaws.com/<repository-name>:<tag>

Once the image is pushed onto the repo navigate to the terraform directory. Run the below command in-order to provision the EKS cluster and the several dependencies that are necessary for the project.

    ## used to initialize the backed and download the provider dependency
    terraform init
    ## run to be sure if there is no error before actual resource provisioning
    terraform plan
    ## Finally run this to start provisioing this resouce
    terraform apply

This may take a long time and may run for 20-30 minutes.

Once done run the yml files in the order.

    kubectl apply -f Namespace.yml
    kubectl apply -f Internal_Service.yml
    kubectl apply -f Ingress.yml
    kubectl apply -f Deployment.yml
