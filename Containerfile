FROM golang:1.23
WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download
COPY *.go ./

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /OTEL-BasicApp

CMD ["/OTEL-BasicApp"]
