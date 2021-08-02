FROM gcr.io/google.com/cloudsdktool/cloud-sdk:alpine

# install full glibc - GNU libc library (libc provides the standard C library and POSIX API)
# Source: https://github.com/anapsix/docker-alpine-java
ENV GLIBC_REPO=https://github.com/sgerrand/alpine-pkg-glibc
ENV GLIBC_VERSION=2.33-r0
RUN set -ex && \
    apk del libc6-compat --quiet && \
    apk update && \
    apk add --no-cache \
    libstdc++ curl ca-certificates && \
    for pkg in glibc-${GLIBC_VERSION} glibc-bin-${GLIBC_VERSION}; \
        do curl -sSL ${GLIBC_REPO}/releases/download/${GLIBC_VERSION}/${pkg}.apk -o /tmp/${pkg}.apk; done && \
    apk add --allow-untrusted /tmp/*.apk && \
    rm -v /tmp/*.apk && \
    /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib

RUN apk add --no-cache \
      maven git openssh gnupg libxml2-utils vim

RUN apk --no-cache add openjdk11 --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community

COPY ./add-ssh-key.sh /usr/local/bin
COPY ./release.sh /usr/local/bin
COPY ./prepare.sh /usr/local/bin
COPY ./settings.xml /usr/share/maven/conf
COPY ./simplelogger.properties /usr/share/java/maven-3/conf/logging/simplelogger.properties

ENV GIT_SSH=/usr/bin/ssh

RUN mkdir /root/.m2
