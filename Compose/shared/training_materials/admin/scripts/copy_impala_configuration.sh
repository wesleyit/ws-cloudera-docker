#!/bin/bash

copyConfigFiles() {
  scp /etc/impala/conf/core-site.xml root@tiger:/etc/impala/conf/
  scp /etc/impala/conf/core-site.xml root@horse:/etc/impala/conf/
  scp /etc/impala/conf/core-site.xml root@monkey:/etc/impala/conf/
  scp /etc/impala/conf/hdfs-site.xml root@tiger:/etc/impala/conf/
  scp /etc/impala/conf/hdfs-site.xml root@horse:/etc/impala/conf/
  scp /etc/impala/conf/hdfs-site.xml root@monkey:/etc/impala/conf/
  scp /etc/impala/conf/hive-site.xml root@tiger:/etc/impala/conf/
  scp /etc/impala/conf/hive-site.xml root@horse:/etc/impala/conf/
  scp /etc/impala/conf/hive-site.xml root@monkey:/etc/impala/conf/
  scp /etc/impala/conf/log4j.properties root@tiger:/etc/impala/conf/
  scp /etc/impala/conf/log4j.properties root@horse:/etc/impala/conf/
  scp /etc/impala/conf/log4j.properties root@monkey:/etc/impala/conf/
  scp /etc/default/impala root@tiger:/etc/default/impala
  scp /etc/default/impala root@horse:/etc/default/impala
  scp /etc/default/impala root@monkey:/etc/default/impala
}

MYHOST="`hostname`: "
echo 
echo $MYHOST "Running " $0"."
copyConfigFiles
echo 
echo $MYHOST $0 "done."
