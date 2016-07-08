## BUILDING
##   (from project root directory)
##   $ docker build -t rickspencer3-revel-dev-container .
##
## RUNNING
##   $ docker run rickspencer3-revel-dev-container

FROM gcr.io/stacksmith-images/debian-buildpack:wheezy-r07

MAINTAINER Bitnami <containers@bitnami.com>

ENV STACKSMITH_STACK_ID="n7dnqby" \
    STACKSMITH_STACK_NAME="rickspencer3/revel-dev-container" \
    STACKSMITH_STACK_PRIVATE="1"

RUN bitnami-pkg install go-1.6.2-1 --checksum 73f6ebc11da5d2b76044c924090919c08e5c39329bce1b3fcac3854c31625d43

ENV GOPATH=/gopath
ENV PATH=$GOPATH/bin:/opt/bitnami/go/bin:$PATH

## STACKSMITH-END: Modifications below this line will be unchanged when regenerating

RUN go get github.com/revel/cmd/revel
ENV GOPATH=$GOPATH:/app

COPY ./revel-entrypoint.sh /
ENTRYPOINT ["/revel-entrypoint.sh"]

EXPOSE 9000

WORKDIR /app
