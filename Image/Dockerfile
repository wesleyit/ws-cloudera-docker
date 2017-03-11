FROM centos:6
MAINTAINER Wesley R. Silva <wesley.it@gmail.com>

RUN yum install -y sudo vim
RUN echo 'training ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/training
RUN useradd training -m -s /bin/bash -d /home/training
RUN echo 'training:training' | chpasswd

ADD ./software /home/training/software
ADD ./cloudera-cdh5.repo /etc/yum.repos.d/
ADD ./cloudera-manager.repo /etc/yum.repos.d/

RUN yum install -y hadoop-hdfs-datanode \
			hadoop-hdfs-namenode \
			hadoop-hdfs-secondarynamenode \
			hadoop-mapreduce \
			hadoop-mapreduce-historyserver \
			hadoop-yarn-nodemanager \
			hadoop-yarn-resourcemanager

RUN yum install -y oracle-j2sdk1.7
ENV JAVA_HOME /usr/java/jdk1.7.0_45-cloudera/
ENV PATH $JAVA_HOME/bin:$PATH

RUN yum install -y spark-master.noarch  \
			spark-python.noarch spark-worker.noarch spark-core.noarch

RUN yum install -y hive hive-hbase impala impala-server \
			impala-state-store impala-catalog impala-shell 

# -- This is new

RUN yum install -y sqoop mysql-connector-java mysql
RUN ln -s /usr/share/java/mysql-connector-java.jar /usr/lib/sqoop/lib/

RUN yum install -y flume-ng flume-ng-agent

