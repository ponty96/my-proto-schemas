# The context for this Dockerfile is the root of this repository.

FROM golang:1.22-alpine3.20

RUN apk --no-cache --update add make bash curl git build-base openssh

RUN apk update && \
    apk --no-cache --update add protobuf openssh

# Pin the version of protoc for now because this triggers deprecation
# warnings downstream in event-jsonizer
# This method is super gross but needed to do this way outside of the gopath
# RUN git clone https://github.com/golang/protobuf.git
# RUN (cd protobuf && git checkout v1.5.4 && go install ./protoc-gen-go)

RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@latest

ADD . .
RUN go mod download

COPY ./entrypoint.sh /entrypoint.sh
WORKDIR /build

CMD ["/entrypoint.sh"]
