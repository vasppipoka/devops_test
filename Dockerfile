FROM golang:1.19.0-bullseye
RUN mkdir /app
ADD . /app
WORKDIR /app
RUN go mod init app
RUN go mod tidy
RUN go build -o main .
CMD ["/app/main"]