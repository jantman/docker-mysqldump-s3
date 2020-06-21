#!/bin/bash -ex

[[ -z "${MYSQL_HOST}" ]] && { >&2 echo "ERROR: Environment variable MYSQL_HOST is not set."; exit 1; }
[[ -z "${MYSQL_USER}" ]] && { >&2 echo "ERROR: Environment variable MYSQL_USER is not set."; exit 1; }
[[ -z "${MYSQL_PASS}" ]] && { >&2 echo "ERROR: Environment variable MYSQL_PASS is not set."; exit 1; }
[[ -z "${BUCKET_NAME}" ]] && { >&2 echo "ERROR: Environment variable BUCKET_NAME is not set."; exit 1; }
[[ -z "${MYSQLDUMP_OPTS}" ]] && MYSQLDUMP_OPTS='--verbose --comments --create-options --dump-date --routines --triggers'
[[ -z "${DUMP_DATE_FORMAT}" ]] && DUMP_DATE_FORMAT='%H'
[[ -z "${BUCKET_PREFIX}" ]] && BUCKET_PREFIX='mariadb_backups/'
[[ -z "${SKIP_DBS}" ]] && SKIP_DBS='information_schema,mysql,performance_schema'

OLDIFS=$IFS
IFS=','
read -ra SKIP <<< "$SKIP_DBS"
IFS=$OLDIFS

TMPDIR=$(mktemp -d)

for dbname in $(mysql --batch --skip-pager --skip-column-names --raw --execute="SHOW DATABASES;" -u"${MYSQL_USER}" -p"${MYSQL_PASS}" -h "${MYSQL_HOST}"); do
  if [[ " ${SKIP[@]} " =~ " ${dbname} " ]]; then
    echo "SKIP_TABLES includes DB ${dbname}; skipping"
    continue
  fi
  mysqldump $MYSQLDUMP_OPTS -u"${MYSQL_USER}" -p"${MYSQL_PASS}" -h "${MYSQL_HOST}" ${dbname} > ${TMPDIR}/dump_${dbname}_$(date +${DUMP_DATE_FORMAT}).sql
done

/usr/bin/aws s3 sync ${TMPDIR} s3://${BUCKET_NAME}/${BUCKET_PREFIX}
