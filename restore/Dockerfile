FROM alpine:latest

RUN apk add --no-cache bash coreutils docker-cli postgresql-client rsync

COPY restore.sh /usr/local/bin/restore.sh
COPY sync.sh /usr/local/bin/sync.sh
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/*.sh

WORKDIR /app
CMD ["entrypoint.sh"]
