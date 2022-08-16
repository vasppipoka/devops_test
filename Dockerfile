FROM golang:1.19.0-bullseye
ENV APPNAME go_ninja
ENV repo https://github.com/vasppipoka/devops_test
RUN mkdir /${APPNAME}
RUN git clone ${repo} /${APPNAME}
RUN chmod 777 /${APPNAME}
WORKDIR /${APPNAME}
RUN go mod init app
RUN go mod tidy
RUN go build -o main .
EXPOSE 8000
CMD ["/go_ninja/main"]