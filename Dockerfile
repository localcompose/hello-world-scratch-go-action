# ------------------------------------------------------------
# Build stage: compile a static Go binary
# ------------------------------------------------------------
FROM golang:1.22-alpine AS builder

# Set working directory inside the build container
WORKDIR /app

# Copy module files first (better caching when users modify code)
COPY go.mod go.sum ./
RUN go mod download

# Copy the rest of the source code
COPY . .

# Build statically for scratch (no libc dependency)
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build -o action -ldflags="-s -w" ./cmd/action

# ------------------------------------------------------------
# Final stage: produce tiny scratch image
# ------------------------------------------------------------
FROM scratch

# Copy static binary
COPY --from=builder /app/action /action

# Entrypoint is the binary itself
ENTRYPOINT ["/action"]
