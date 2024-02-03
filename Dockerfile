# Use the official Ubuntu base image
FROM ubuntu:latest

# Set environment variables for Hadoop
ENV HADOOP_HOME /usr/local/hadoop
ENV PATH $HADOOP_HOME/bin:$PATH
ENV HDFS_NAMENODE_USER=root
ENV HDFS_DATANODE_USER=root
ENV HDFS_SECONDARYNAMENODE_USER=root
ENV YARN_NODEMANAGER_USER=root
ENV YARN_RESOURCEMANAGER_USER=root


# Install necessary dependencies
RUN apt-get update && \
    apt-get install -y ssh openjdk-8-jdk neovim junit python-is-python3 nano curl python3-pip

# Download and extract Hadoop
RUN mkdir -p $HADOOP_HOME
RUN wget -O hadoop.tar.gz https://downloads.apache.org/hadoop/common/stable/hadoop-3.3.6.tar.gz
RUN tar -xzvf hadoop.tar.gz -C $HADOOP_HOME --strip-components=1

# Configure SSH
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 0600 ~/.ssh/authorized_keys

RUN wget -O /usr/local/hadoop/lib/javax.activation-api-1.2.0.jar https://jcenter.bintray.com/javax/activation/javax.activation-api/1.2.0/javax.activation-api-1.2.0.jar

RUN mkdir -p /home/hadoop/hdfs/{namenode,datanode}
RUN chown -R $USER:$USER /home/hadoop/hdfs

# Hadoop configuration
COPY core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml
COPY hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml
COPY mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml
COPY yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml

RUN echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> ~/.bashrc && \
    echo "export HADOOP_HOME=/usr/local/hadoop" >> ~/.bashrc && \
    echo "export HADOOP_INSTALL=\$HADOOP_HOME" >> ~/.bashrc && \
    echo "export HADOOP_MAPRED_HOME=\$HADOOP_HOME" >> ~/.bashrc && \
    echo "export HADOOP_COMMON_HOME=\$HADOOP_HOME" >> ~/.bashrc && \
    echo "export HADOOP_HDFS_HOME=\$HADOOP_HOME" >> ~/.bashrc && \
    echo "export YARN_HOME=\$HADOOP_HOME" >> ~/.bashrc && \
    echo "export HADOOP_COMMON_LIB_NATIVE_DIR=\$HADOOP_HOME/lib/native" >> ~/.bashrc && \
    echo "export PATH=\$PATH:\$HADOOP_HOME/sbin:\$HADOOP_HOME/bin" >> ~/.bashrc && \
    echo "export HADOOP_OPTS=\"-Djava.library.path=\$HADOOP_HOME/lib/native\"" >> ~/.bashrc

RUN echo "HDFS_NAMENODE_USER=root" >> /usr/local/hadoop/etc/hadoop/hadoop-env.sh && \
    echo "HDFS_DATANODE_USER=root" >> /usr/local/hadoop/etc/hadoop/hadoop-env.sh && \
    echo "HDFS_SECONDARYNAMENODE_USER=root" >> /usr/local/hadoop/etc/hadoop/hadoop-env.sh && \
    echo "YARN_NODEMANAGER_USER=root" >> /usr/local/hadoop/etc/hadoop/hadoop-env.sh && \
    echo "YARN_RESOURCEMANAGER_USER=root" >> /usr/local/hadoop/etc/hadoop/hadoop-env.sh && \
    echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> /usr/local/hadoop/etc/hadoop/hadoop-env.sh && \
    echo "export HADOOP_CLASSPATH+=\" \$HADOOP_HOME/lib/*.jar\"" >> /usr/local/hadoop/etc/hadoop/hadoop-env.sh

# Copy init and restart scripts
COPY restart $HADOOP_HOME/bin/restart
COPY init $HADOOP_HOME/bin/init
RUN chmod +x $HADOOP_HOME/bin/restart
RUN chmod +x $HADOOP_HOME/bin/init

# Install pig
RUN wget -O pig.tar.gz https://downloads.apache.org/pig/pig-0.17.0/pig-0.17.0.tar.gz
RUN tar -xzvf pig.tar.gz
RUN mv pig-0.17.0 /pig
RUN echo "export PIG_HOME=/pig" >> ~/.bashrc && \
    echo "export PATH=\$PATH:/pig/bin" >> ~/.bashrc && \
    echo "export PIG_CLASSPATH=\$HADOOP_HOME/etc/hadoop" >> ~/.bashrc

# Install hbase
RUN wget http://apache.mirror.gtcomm.net/hbase/stable/hbase-2.5.7-bin.tar.gz
RUN tar -xzvf hbase-2.5.7-bin.tar.gz
RUN mv hbase-2.5.7 /usr/local/hbase
RUN echo "export HBASE_HOME=/usr/local/hbase" >> ~/.bashrc && \
    echo "export PATH=\$PATH:\$HBASE_HOME/bin" >> ~/.bashrc
RUN echo "export HBASE_DISABLE_HADOOP_CLASSPATH_LOOKUP=\"true\"" >> /usr/local/hbase/conf/hbase-env.sh && \
    echo "JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/" >> /usr/local/hbase/conf/hbase-env.sh
COPY hbase-site.xml ~/hbase-site.xml

RUN mkdir -p /hadoop/zookeeper
RUN chown -R $USER:$USER /hadoop/

# Install Hive
RUN wget https://dlcdn.apache.org/hive/hive-3.1.3/apache-hive-3.1.3-bin.tar.gz
RUN tar -xzvf apache-hive-3.1.3-bin.tar.gz
RUN mv apache-hive-3.1.3-bin /usr/local/hive
RUN echo "export HIVE_HOME=/usr/local/hive" >> ~/.bashrc && \
    echo "export PATH=\$PATH:\$HIVE_HOME/bin" >> ~/.bashrc
RUN echo "HADOOP_HOME=/usr/local/hadoop" >> /usr/local/hive/bin/hive-config.sh

# Install Flume
RUN wget https://archive.apache.org/dist/flume/1.9.0/apache-flume-1.9.0-bin.tar.gz
RUN tar -xzvf apache-flume-1.9.0-bin.tar.gz
RUN mv apache-flume-1.9.0-bin /usr/local/flume
RUN echo "export FLUME_HOME=/usr/local/flume" >> ~/.bashrc && \
    echo "export PATH=\$PATH:\$FLUME_HOME/bin" >> ~/.bashrc
RUN sed -i '214c\  \$EXEC \$JAVA_HOME/java \$JAVA_OPTS \$FLUME_JAVA_OPTS "\${arr_java_props[@]}" -cp "\$FLUME_CLASSPATH" \\' /usr/local/flume/bin/flume-ng

# Install Sqoop
RUN wget https://archive.apache.org/dist/sqoop/1.4.7/sqoop-1.4.7.bin__hadoop-2.6.0.tar.gz
RUN tar -xzvf sqoop-1.4.7.bin__hadoop-2.6.0.tar.gz
RUN mv sqoop-1.4.7.bin__hadoop-2.6.0 /usr/local/sqoop
RUN echo "export SQOOP_HOME=/usr/local/sqoop" >> ~/.bashrc && \
    echo "export PATH=\$PATH:\$SQOOP_HOME/bin" >> ~/.bashrc
RUN mv /usr/local/sqoop/conf/sqoop-env-template.sh /usr/local/sqoop/conf/sqoop-env.sh
RUN echo "export HADOOP_COMMON_HOME=/usr/local/hadoop" >> /usr/local/sqoop/conf/sqoop-env.sh && \
    echo "export HADOOP_MAPRED_HOME=/usr/local/hadoop" >> /usr/local/sqoop/conf/sqoop-env.sh

# Install Zookeeper
RUN wget https://downloads.apache.org/zookeeper/zookeeper-3.9.1/apache-zookeeper-3.9.1-bin.tar.gz
RUN tar -xvf apache-zookeeper-3.9.1-bin.tar.gz
RUN mv apache-zookeeper-3.9.1-bin /usr/local/zookeeper
RUN mv /usr/local/zookeeper/conf/zoo_sample.cfg /usr/local/zookeeper/conf/zoo.cfg
RUN echo "export ZOOKEEPER_HOME=/usr/local/zookeeper" >> ~/.bashrc && \
    echo "export PATH=\$PATH:\$ZOOKEEPER_HOME/bin" >> ~/.bashrc

# Install Spark
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y scala git
RUN wget https://archive.apache.org/dist/spark/spark-3.4.1/spark-3.4.1-bin-hadoop3.tgz
RUN tar -xf spark-3.4.1-bin-hadoop3.tgz
RUN mv spark-3.4.1-bin-hadoop3 /usr/local/spark
RUN echo "export SPARK_HOME=/usr/local/spark" >> ~/.bashrc && \
    echo "export PATH=\$PATH:\$SPARK_HOME/bin:\$SPARK_HOME/sbin" >> ~/.bashrc

# Install Pyspark
RUN pip install pyspark

# Install Kafka
RUN wget https://downloads.apache.org/kafka/3.6.1/kafka_2.13-3.6.1.tgz
RUN tar -xzvf kafka_2.13-3.6.1.tgz
RUN mv kafka_2.13-3.6.1 /usr/local/kafka
RUN echo "export KAFKA_HOME=/usr/local/kafka" >> ~/.bashrc && \
    echo "export PATH=\$PATH:\$KAFKA_HOME/bin" >> ~/.bashrc

# Install Postgresql
RUN apt-get install postgresql postgresql-contrib

# Connect Postgresql with sqoop
RUN wget https://jdbc.postgresql.org/download/postgresql-42.7.1.jar
RUN mv postgresql-42.7.1.jar /usr/local/sqoop/lib/postgresql-42.7.1.jar
RUN rm commons-lang3-3.4.jar
RUN wget https://dlcdn.apache.org//commons/lang/binaries/commons-lang-2.6-bin.tar.gz
RUN tar -xvf commons-lang-2.6-bin.tar.gz
RUN mv commons-lang-2.6-bin/* /usr/local/sqoop/lib
RUN rm -rf commons-lang-2.6-bin
RUN mkdir /usr/local/sqoop/conf/manager.d
RUN echo "org.postgresql.Driver=/usr/lib/sqoop/lib/postgresql-42.7.1.jar" > postgresql

# Expose necessary ports
EXPOSE 9870 8088 9000

ENTRYPOINT ["/bin/bash", "-c"]
CMD ["bash"]
