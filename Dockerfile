FROM gcr.io/google.com/cloudsdktool/cloud-sdk:alpine

RUN apk update && apk add maven git openssh gnupg libxml2-utils vim
RUN apk --no-cache add openjdk11 --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community

COPY ./add-ssh-key.sh /usr/local/bin
COPY ./release.sh /usr/local/bin
COPY ./settings.xml /usr/share/maven/conf
COPY ./simplelogger.properties /usr/share/java/maven-3/conf/logging/simplelogger.properties

ENV GIT_SSH=/usr/bin/ssh

RUN mkdir /root/.m2
