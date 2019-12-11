FROM centos:7

RUN yum install java-1.8.0-openjdk-devel.x86_64 wget -y 
ADD install-maven.sh .
ARG MAVEN_VERSION='3.6.0'
RUN ./install-maven.sh $MAVEN_VERSION

ARG BUILD_DATE
ARG VCS_URL
ARG VCS_REF
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url=$VCS_URL \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.schema-version="1.0.0"

ENV JAVA_HOME='/usr/lib/jvm/java-1.8.0-openjdk'
ENV PATH="${PATH}:${JAVA_HOME}/bin"
ARG WORKING_DIR='/'
WORKDIR "$WORKING_DIR"
CMD ["/bin/bash"]
