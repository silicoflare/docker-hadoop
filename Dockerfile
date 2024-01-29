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
    apt-get install -y ssh && \
    apt-get install -y openjdk-8-jdk && \
    apt-get install -y neovim && \
    rm -rf /var/lib/apt/lists/*

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

RUN echo "export HADOOP_HOME=/usr/local/hadoop" >> ~/.bashrc
RUN echo "export HADOOP_INSTALL=\$HADOOP_HOME" >> ~/.bashrc
RUN echo "export HADOOP_MAPRED_HOME=\$HADOOP_HOME" >> ~/.bashrc
RUN echo "export HADOOP_COMMON_HOME=\$HADOOP_HOME" >> ~/.bashrc
RUN echo "export HADOOP_HDFS_HOME=\$HADOOP_HOME" >> ~/.bashrc
RUN echo "export YARN_HOME=\$HADOOP_HOME" >> ~/.bashrc
RUN echo "export HADOOP_COMMON_LIB_NATIVE_DIR=\$HADOOP_HOME/lib/native" >> ~/.bashrc
RUN echo "export PATH=\$PATH:\$HADOOP_HOME/sbin:\$HADOOP_HOME/bin" >> ~/.bashrc
RUN echo "export HADOOP_OPTS=\"-Djava.library.path=\$HADOOP_HOME/lib/native\"" >> ~/.bashrc

RUN echo "HDFS_NAMENODE_USER=root" >> /usr/local/hadoop/etc/hadoop/hadoop-env.sh
RUN echo "HDFS_DATANODE_USER=root" >> /usr/local/hadoop/etc/hadoop/hadoop-env.sh
RUN echo "HDFS_SECONDARYNAMENODE_USER=root" >> /usr/local/hadoop/etc/hadoop/hadoop-env.sh
RUN echo "YARN_NODEMANAGER_USER=root" >> /usr/local/hadoop/etc/hadoop/hadoop-env.sh
RUN echo "YARN_RESOURCEMANAGER_USER=root" >> /usr/local/hadoop/etc/hadoop/hadoop-env.sh
RUN echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> /usr/local/hadoop/etc/hadoop/hadoop-env.sh
RUN echo "export HADOOP_CLASSPATH+=\" \$HADOOP_HOME/lib/*.jar\"" >> /usr/local/hadoop/etc/hadoop/hadoop-env.sh

RUN toouch /usr/local/hadoop/restart-all.sh
RUN echo "service ssh restart" >> /usr/local/hadoop/restart-all.sh
RUN echo "stop-all.sh" >> /usr/local/hadoop/restart-all.sh
RUN echo "start-all.sh" >> /usr/local/hadoop/restart-all.sh
RUN echo "jps" >> /usr/local/hadoop/restart-all.sh
RUN chmod +x /usr/local/hadoop/restart-all.sh

# Expose necessary ports
EXPOSE 9870 8088 9000
