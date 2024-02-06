FROM openjdk:8-jre-slim

WORKDIR /opt

ENV HADOOP_VERSION=3.2.4
ENV HIVE_VERSION=3.1.3
ENV MYSQL_VERSION=8.0.19
ENV TEZ_VERSION=0.9.2

RUN apt-get update && \
    apt-get install -y curl netcat --no-install-recommends procps && \
    apt-get clean

ENV HADOOP_HOME=/opt/hadoop \
    HIVE_HOME=/opt/hive \
    TEZ_HOME=/opt/tez \
    JAVA_HOME=/usr/local/openjdk-8 \
    HIVE_CONF_DIR=$HIVE_HOME/conf

# Download and install Hadoop & standalone Hive metastore
RUN curl -L https://dlcdn.apache.org/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz | tar zxf - && \
    mv hadoop-${HADOOP_VERSION} ${HADOOP_HOME} && \
    curl -L https://dlcdn.apache.org/hive/hive-${HIVE_VERSION}/apache-hive-${HIVE_VERSION}-bin.tar.gz | tar zxf - && \
    mv apache-hive-${HIVE_VERSION}-bin ${HIVE_HOME} && \
    curl -L https://dlcdn.apache.org/tez/${TEZ_VERSION}/apache-tez-${TEZ_VERSION}-bin.tar.gz | tar zxf - && \
    mv apache-tez-${TEZ_VERSION}-bin ${TEZ_HOME}

# fix guava version issue on hive and hadoop
RUN rm /opt/hive/lib/guava*.jar && cp /opt/hadoop/share/hadoop/common/lib/guava*.jar /opt/hive/lib

# Need s3 jars
RUN cp $HADOOP_HOME/share/hadoop/tools/lib/aws-java-sdk*.jar ${HIVE_HOME}/lib/ && \
    cp $HADOOP_HOME/share/hadoop/tools/lib/hadoop-aws-*.jar ${HIVE_HOME}/lib/

# Download and install MySQL jar used by Hive metastore
RUN curl -L https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-${MYSQL_VERSION}.tar.gz | tar zxf - && \
    cp mysql-connector-java-${MYSQL_VERSION}/mysql-connector-java-${MYSQL_VERSION}.jar ${HIVE_HOME}/lib/ && \
    rm -rf  mysql-connector-java-${MYSQL_VERSION}

ENV PATH=/opt/hive/bin:/opt/hadoop/bin:/usr/local/openjdk-8/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    HADOOP_CLASSPATH=$TEZ_HOME/*:$TEZ_HOME/lib/* \
    HIVE_AUX_JARS_PATH=$HADOOP_CLASSPATH

COPY entrypoint.sh /entrypoint.sh

# Assign permissions
RUN groupadd -r hive --gid=1000
RUN useradd -r -g hive --uid=1000 -d ${HIVE_HOME} hive
RUN mkdir -p /opt/hive/data/warehouse
RUN chown hive:hive -R /opt && \
    chown hive:hive /entrypoint.sh && \
    chmod +x /entrypoint.sh

USER hive

EXPOSE 9083

CMD ["sh", "-c", "/entrypoint.sh"]