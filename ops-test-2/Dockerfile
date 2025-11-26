FROM golang:1.24 AS builder

WORKDIR /build

COPY app/go.mod ./

RUN go mod download

COPY app .

RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o server .

FROM alpine

RUN apk add --no-cache ca-certificates \
    && addgroup -S appgroup \
    && adduser -S appuser -G appgroup

COPY --from=builder /build/server /bin/server

RUN chown appuser:appgroup /bin/server

USER appuser

EXPOSE 8080

ENTRYPOINT ["/bin/server"]
