FROM alpine:latest

RUN apk add --no-cache bash coreutils docker-cli postgresql-client

COPY backup.sh /usr/local/bin/backup.sh
RUN chmod +x /usr/local/bin/backup.sh

WORKDIR /app
CMD ["backup.sh"]
