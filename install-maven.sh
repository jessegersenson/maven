#!/bin/bash
set -e
set -o pipefail
set -o nounset

##########################################################################
#### DESCRIPTION: installs maven, a build tool to make java JAR files
#### OS: runs only on Linux
#### AUTHOR: Jesse Gersenson
#### USAGE: ./thisscript.sh
#### FUTURE ISSUES: version of maven will need to be updated in $MAVEN_VERSION and URL of download may change 
##########################################################################
 

MAVEN_VERSION="$1"
#MAVEN_VERSION='3.6.3'

PROJECT='myProject'
LOG_DIR="./"
LOG_FILENAME="${PROJECT}-deploy-$(date -u +'%F%H%M%S').log"
LOG="${LOG_DIR}/${LOG_FILENAME}"

TMP_DIR="/tmp"
USR_BIN='/usr/bin'
FILE="apache-maven-${MAVEN_VERSION}-bin.tar.gz"
CHECKSUM_FILE="${FILE}.sha512"

export JAVA_HOME='/usr/lib/jvm/java-1.8.0-openjdk'
export PATH=$PATH:$JAVA_HOME/bin

function now(){
    date -u +'%Y-%m-%d-%H%M%S.%3N'
}

function log(){
    entry="$@"
    echo "t:$(now) ${entry}" | tee -a "$LOG"
}

function error() {
    log "$@" 1>&2; exit 1
}

function run() {
    log "RUN: $@"            
    "$@"
}

function is_linux(){
	if [[ ! $(uname -s) == 'Linux' ]]
	then
		log "ERROR: script can not run on $(uname -s)"
		log "FATAL: $0 FAILED. This script can only run on linux systems"
		exit
	fi
}

function get_maven(){
	if [[ $(wget -O "${TMP_DIR}/${FILE}" "https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/${FILE}") -eq 0 ]]
	then
		log "INFO: Success, https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/${FILE} downloaded"
	else
		log "ERROR: in file $0. wget failed. Error code: $?"
		log "FATAL: aborting"
		exit
	fi
}

function get_checksum(){
	if [[ $(wget -O "${TMP_DIR}/${CHECKSUM_FILE}" "https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/${CHECKSUM_FILE}") -eq 0 ]]
	then
		log "INFO: Successfuly downloaded checksum_file:$CHECKSUM_FILE"	
	else
		log "ERROR: in file $0, wget failed. Error code: $?"
		log "FATAL: aborting"
		exit
	fi
}

function check_checksum(){
	#### check checksum ####
	if [[ ! $(cat "${TMP_DIR}/$CHECKSUM_FILE" | cut -f1 -d' ') == $(sha512sum "${TMP_DIR}/$FILE" | cut -f1 -d' ') ]]; 
	then 
		log "$(date) ERROR in $0: maven failed to install because checksum of $CHECKSUM_FILE does not match $FILE"
		exit
	fi
}

run is_linux
run get_maven
run get_checksum
run check_checksum

#### untar ####
run tar zxf "${TMP_DIR}/$FILE" -C "${USR_BIN}/"
rm "${TMP_DIR}/$FILE" "${TMP_DIR}/${CHECKSUM_FILE}"
yum clean metadata

#### symlink ####
run ln -fs "${USR_BIN}/apache-maven-${MAVEN_VERSION}/bin/mvn" "${USR_BIN}/mvn"

