## BUILDING
##   (from project root directory)
##   $ docker build -t go-for-rickspencer3-revel-dev-container .
##
## RUNNING
##   $ docker run go-for-rickspencer3-revel-dev-container

FROM gcr.io/stacksmith-images/debian-buildpack:wheezy-r10

MAINTAINER Bitnami <containers@bitnami.com>

ENV STACKSMITH_STACK_ID="hums77l" \
    STACKSMITH_STACK_NAME="Go for rickspencer3/revel-dev-container" \
    STACKSMITH_STACK_PRIVATE="1"

RUN bitnami-pkg install go-1.7.3-0 --checksum 5e41f1a5c05597245b391189f4d11ea5ddd21e9114d341a01c331d7469efb4f4

ENV GOPATH=/gopath
ENV PATH=$GOPATH/bin:/opt/bitnami/go/bin:$PATH

## STACKSMITH-END: Modifications below this line will be unchanged when regenerating

RUN go get github.com/revel/cmd/revel
RUN go get github.com/go-sql-driver/mysql
ENV GOPATH=$GOPATH:/app

COPY ./revel-entrypoint.sh /
ENTRYPOINT ["/revel-entrypoint.sh"]

EXPOSE 9000

WORKDIR /app
