FROM golang:1.19.0-bullseye
ENV APPNAME go_ninja
RUN mkdir /app
RUN git clone https://github.com/getninjas/devops_test /app
RUN chmod 777 /app
WORKDIR /app
RUN go mod init app
RUN go mod tidy
RUN go build -o main .
CMD ["/app/main"]