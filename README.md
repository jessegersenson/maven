# Dockerfile to install and run Maven

#### build ####
docker build -t centos7/maven .
docker build -t centos7/maven --build-arg MAVEN_VERSION=3.6.0 --build-arg WORKING_DIR=/somewhere .


#### run ####
docker run -i --rm --name centos7/maven:latest sh -c 'mvn -v'

#### todo ####
