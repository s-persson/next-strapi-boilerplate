FROM alpine:latest

RUN apk add --no-cache bash coreutils docker-cli postgresql-client

COPY script.sh /usr/local/bin/script.sh
RUN chmod +x /usr/local/bin/script.sh

WORKDIR /app
CMD ["script.sh"]
