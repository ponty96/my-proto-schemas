# The context for this Dockerfile is the root of this repository.

FROM golang:1.22-alpine3.20

RUN apk --no-cache --update add make bash curl git build-base openssh

RUN apk update && \
    apk --no-cache --update add protobuf-dev openssh

RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
RUN go install github.com/envoyproxy/protoc-gen-validate@latest

# (Optional) Confirm protoc and the well-known types are installed:
RUN protoc --version
RUN ls -l /usr/include/google/protobuf/

RUN git clone https://github.com/envoyproxy/protoc-gen-validate.git /proto-validate && \
    cp -r /proto-validate/validate /usr/include/

ADD . .

RUN go mod download

COPY ./entrypoint.sh /entrypoint.sh
WORKDIR /build

CMD ["/entrypoint.sh"]
