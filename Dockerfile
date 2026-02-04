FROM --platform=$BUILDPLATFORM golang:1.18-alpine AS builder

WORKDIR /src
COPY cmd/prom-aggregation-gateway/go.mod cmd/prom-aggregation-gateway/go.sum ./
RUN go mod download

COPY cmd/prom-aggregation-gateway/ ./
RUN CGO_ENABLED=0 GOOS=linux GOARCH=$TARGETARCH go build -o /prom-aggregation-gateway

FROM --platform=$TARGETPLATFORM alpine:3.19

COPY --from=builder /prom-aggregation-gateway /prom-aggregation-gateway

ENTRYPOINT ["/prom-aggregation-gateway"]
