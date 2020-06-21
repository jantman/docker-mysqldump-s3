FROM alpine:3.12
LABEL vendor=jasonantman.com org.label-schema.url="https://github.com/jantman/docker-mysqldump-s3" org.label-schema.vcs-url="https://github.com/jantman/docker-mysqldump-s3"
ENV LANG C.UTF-8

RUN apk add --no-cache mariadb-client py3-pip bash
RUN set -ex \
	# && apk add --no-cache --virtual .build-deps gcc \
  && /usr/bin/pip3 install awscli
ADD backup_dbs.sh /usr/local/bin/
CMD /usr/local/bin/backup_dbs.sh
