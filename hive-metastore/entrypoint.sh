#!/bin/sh

export HADOOP_HOME=/opt/hadoop
AWS_JAVA_SDK=$(ls $HADOOP_HOME/share/hadoop/tools/lib/aws-java-sdk*.jar)
HADOOP_AWS_JAR=$(ls $HADOOP_HOME/share/hadoop/tools/lib/hadoop-aws-*.jar)
export HADOOP_CLASSPATH=${AWS_JAVA_SDK}:${HADOOP_AWS_JAR}
export HIVE_AUX_JARS_PATH=$HADOOP_CLASSPATH
export JAVA_HOME=/usr/local/openjdk-8
export DB_HOSTNAME=${DB_HOSTNAME:-localhost}

echo "Waiting for MySQL database on ${DB_HOSTNAME} to launch..."
while ! nc -z $DB_HOSTNAME 3306; do
    sleep 1
done

echo "Starting Hive metastore service on $DB_HOSTNAME:3306"
/opt/hive/bin/schematool -initSchema -dbType mysql
/opt/hive/bin/start-metastore
