#!/bin/bash

installCDH5() {
  echo 
  echo Installing CDH5 + Cloudera Manager agent packages.
  echo
  sudo yum --assumeyes install hadoop-client hadoop-hdfs hadoop-httpfs hadoop-mapreduce hadoop-yarn hadoop-0.20-mapreduce zookeeper hive hive-webhcat-server impala impala-shell llama-master pig flume-ng sqoop sqoop2 sqoop2-client oozie oozie-client hue-common hue-beeswax hue-hbase hue-impala hue-pig hue-plugins hue-rdbms hue-search hue-spark hue-sqoop hue-zookeeper hue-search hbase solr hbase-solr crunch spark-core spark-python bigtop-jsvc bigtop-utils bigtop-tomcat cloudera-manager-agent cloudera-manager-daemons
}

disableAutostart() {
  echo
  echo Disabling autostart for packages as required by CM Installation Path B.
  echo
  sudo chkconfig oozie off
  sudo chkconfig hadoop-httpfs off
  sudo chkconfig hive-webhcat-server off
}

MYHOST="`hostname`: "
echo 
echo $MYHOST "Running " $0"."
installCDH5
disableAutostart
echo
echo $MYHOST $0 "done."