# Dockerfile to install and run Maven

#### build ####
docker build -t centos7/maven3.6.3 .

#### run ####
docker run -i --rm --name centos7/maven3.6.3:latest sh -c 'mvn -v'

#### todo ####
maven version should be a command line arguement. it is currently defined as a variable in install-maven.sh
