
# Stage 1 - Build
FROM golang:1.26 AS builder
WORKDIR /app
COPY app/ .
RUN CGO_ENABLED=0 GOOS=linux go build -o gatus .

# Stage 2 - Run
FROM alpine:3.20
RUN apk add --no-cache ca-certificates
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
WORKDIR /app
COPY --from=builder /app/gatus .
COPY --from=builder /app/config/config.yaml config/config.yaml
USER appuser
EXPOSE 8080
CMD ["./gatus"]