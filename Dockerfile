# Stage 1. Build the binary
FROM golang:1.11

# add a non-privileged user
RUN useradd -u 10001 myapp

RUN mkdir -p /go/src/golang-workshop/
ADD . /go/src/golang-workshop/
WORKDIR /go/src/golang-workshop/

# build the binary with go build
RUN CGO_ENABLED=0 go build \
	-o bin/go-margita golang-workshop/go-margita

# Stage 2. Run the binary
FROM scratch

ENV PORT 8888
ENV DIAG_PORT 8585



COPY --from=0 /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

COPY --from=0 /etc/passwd /etc/passwd
USER myapp

COPY --from=0 /go/src/golang-workshop/bin/go-margita /go-margita
EXPOSE $PORT
EXPOSE ${DIAG_PORT}

CMD ["/go-margita"]
