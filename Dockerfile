FROM golang:1.13.8 as builder
WORKDIR /go/src/ehang.io/nps
COPY . .
RUN go get -d -v ./... 
RUN CGO_ENABLED=0 go build -ldflags="-w -s -extldflags -static" ./cmd/nps/nps.go

FROM scratch
COPY --from=builder /go/src/ehang.io/nps/nps /
COPY --from=builder /go/src/ehang.io/nps/web /web
VOLUME /conf
CMD ["/nps","--vhost_http_port=8080"]
EXPOSE 80 8080 8284
