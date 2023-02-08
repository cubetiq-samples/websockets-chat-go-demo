FROM golang:1.19.0-alpine3.16 as builder

WORKDIR /usr/app/src

COPY go.mod .
COPY go.sum .

RUN go mod download
COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -o app .

FROM alpine:latest as release

WORKDIR /app

COPY --from=builder /usr/app/src/app .
COPY --from=builder /usr/app/src/*.html .

RUN chmod +x /app/app

CMD [ "./app" ]