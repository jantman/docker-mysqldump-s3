# docker-mysqldump-s3

[![Project Status: Abandoned – Initial development has started, but there has not yet been a stable, usable release; the project has been abandoned and the author(s) do not intend on continuing development.](https://www.repostatus.org/badges/latest/abandoned.svg)](https://www.repostatus.org/#abandoned)

Docker container to run mysqldump on a DB and sync results to S3. Usable as a scheduled job, i.e. an ECS task on a schedule.

## Environment Variables

* ``MYSQL_HOST`` - MySQL host or IP
* ``MYSQL_USER`` - MySQL username
* ``MYSQL_PASS`` - MySQL password
* ``BUCKET_NAME`` - S3 Bucket Name
* _optional_ ``MYSQLDUMP_OPTS`` - Options for running ``mysqldump``. Defaults to: ``--verbose --comments --create-options --dump-date --routines --triggers``
* _optional_ ``DUMP_DATE_FORMAT`` - Format string (passed to ``date``) for backup suffix. Defaults to: ``%H``
* _optional_ ``BUCKET_PREFIX`` - Prefix to sync files to in the S3 bucket. Defaults to: ``mariadb_backups/``
* _optional_ ``SKIP_DBS`` - Comma-separated list of database names to skip dumping. Defaults to: ``information_schema,mysql,performance_schema``
