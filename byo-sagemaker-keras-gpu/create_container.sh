#!/bin/bash

experiment=$1 # The name of our algorithm

# construct the ECR name.
repository=datascience-model-training # The name of our repository folder
echo "repository name : $repository"

account=$(aws sts get-caller-identity --query Account --output text)
echo "account name : $account"

# Get the region defined in the current configuration (default to us-west-2 if none defined)
region=$(aws configure get region)
echo "aws region: $region"

# Generates a fullname for your image, which consists of your ECR home registry string
# plus the name and tag of the image you are about to push.
fullname="${account}.dkr.ecr.${region}.amazonaws.com/${repository}:$2"
echo "fullname of image : $fullname"

chmod +x src/*

# If the repository doesn't exist in ECR, create it.
    aws ecr describe-repositories --repository-names "${repository}" > /dev/null 2>&1

#if [ $? -ne 0 ]
#then
   # create the repository in ECR.
   # aws ecr create-repository --repository-name "${repository_name}" > /dev/null
#fi

# Get the login command from ECR and execute it directly
#$(aws ecr get-login --registry-ids $account --no-include-email)

$(aws ecr get-login --region ${region} --no-include-email)


# Build the docker image locally with the image name and then push it to ECR
# with the full name.

# On a SageMaker Notebook Instance, the docker daemon may need to be restarted in order
# to detect your network configuration correctly.  (This is a known issue.)

#if [ -d "/home/preetam/keras-sagemaker-gpu" ]; then
 # sudo service docker --registry-mirror ${account} restart
#fi

sudo service docker status

# Comment the line below to use a GPU
# Build the docker image, tag it with the full name, and push it to ECR
docker build -t "${experiment}" -f $3  . 

# Uncomment the below line if you wish to run on a GPU
#docker build  -t ${repository_name}/${experiment} -f Dockerfile.gpu . 

docker tag "${experiment}" ${fullname} 

docker --debug push ${fullname}
