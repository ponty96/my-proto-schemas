# The context for this Dockerfile is the root of this repository.

FROM golang:1.22-alpine3.20

RUN apk --no-cache --update add make bash curl git build-base openssh

RUN apk update && \
    apk --no-cache --update add protobuf-dev openssh

RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@latest

# (Optional) Confirm protoc and the well-known types are installed:
RUN protoc --version
RUN ls -l /usr/include/google/protobuf/

ADD . .

RUN go mod download

COPY ./entrypoint.sh /entrypoint.sh
WORKDIR /build

CMD ["/entrypoint.sh"]
