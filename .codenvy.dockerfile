## BUILDING
##   (from project root directory)
##   $ docker build -t rickspencer3-revel-dev-container .
##
## RUNNING
##   $ docker run rickspencer3-revel-dev-container

FROM gcr.io/stacksmith-images/debian-buildpack:wheezy-r8

MAINTAINER Bitnami <containers@bitnami.com>

ENV STACKSMITH_STACK_ID="9ajr5ei" \
    STACKSMITH_STACK_NAME="rickspencer3/revel-dev-container" \
    STACKSMITH_STACK_PRIVATE="1"

RUN bitnami-pkg install go-1.6.3-0 --checksum 8fd706186502cebc35bce121d3a176936153782a9ff4a9e4e93eee76c2ed02cc

ENV GOPATH=/gopath
ENV PATH=$GOPATH/bin:/opt/bitnami/go/bin:$PATH

## STACKSMITH-END: Modifications below this line will be unchanged when regenerating

RUN go get github.com/revel/cmd/revel
RUN go get github.com/go-sql-driver/mysql
ENV GOPATH=$GOPATH:/app

#
# Eclipse Che
#
USER root

RUN echo "%sudo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN bitnami-pkg install java-1.8.0_91-0 --checksum 64cf20b77dc7cce3a28e9fe1daa149785c9c8c13ad1249071bc778fa40ae8773
ENV PATH=/opt/bitnami/java/bin:$PATH

LABEL che:server:3000:ref=revel che:server:3000:protocol=http

EXPOSE 9000

WORKDIR /app
