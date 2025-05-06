FROM alpine:latest

RUN apk add --no-cache bash coreutils docker-cli postgresql-client rsync

COPY restore.sh /usr/local/bin/restore.sh
RUN chmod +x /usr/local/bin/restore.sh

WORKDIR /app
CMD ["restore.sh"]
