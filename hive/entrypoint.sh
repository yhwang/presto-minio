#!/bin/sh

export DB_HOSTNAME=${DB_HOSTNAME:-localhost}

if [ "$SERVICE_NAME" = "metastore" ]; then
    echo "Waiting for MySQL database on ${DB_HOSTNAME} to launch..."
    while ! nc -z $DB_HOSTNAME 3306; do
        sleep 1
    done
    echo "Starting Hive metastore service"
    /opt/hive/bin/schematool -initSchema -dbType mysql
elif [ "$SERVICE_NAME" = "hiveserver2" ]; then
    export HADOOP_CLIENT_OPTS="$HADOOP_CLIENT_OPTS -Xmx1G $SERVICE_OPTS"

    echo "Starting Hive service"
fi
/opt/hive/bin/hive --skiphadoopversion --skiphbasecp --service "$SERVICE_NAME"

