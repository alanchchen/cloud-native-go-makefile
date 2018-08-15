# First stage container
FROM golang:1.10-alpine as builder

RUN apk add --no-cache make

ADD . /src
RUN cd /src && make && mkdir -p /build/bin && mv build/bin/* /build/bin

# Second stage container
FROM alpine:latest

RUN apk add --no-cache ca-certificates
COPY --from=builder /build/bin/* /usr/local/bin/

# Define your entrypoint or command
# ENTRYPOINT [""]
