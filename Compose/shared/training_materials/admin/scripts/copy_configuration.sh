#!/bin/bash

copyConfigFiles() {
  scp /etc/hadoop/conf/core-site.xml root@tiger:/etc/hadoop/conf/
  scp /etc/hadoop/conf/core-site.xml root@horse:/etc/hadoop/conf/
  scp /etc/hadoop/conf/core-site.xml root@monkey:/etc/hadoop/conf/
  scp /etc/hadoop/conf/hdfs-site.xml root@tiger:/etc/hadoop/conf/
  scp /etc/hadoop/conf/hdfs-site.xml root@horse:/etc/hadoop/conf/
  scp /etc/hadoop/conf/hdfs-site.xml root@monkey:/etc/hadoop/conf/
  scp /etc/hadoop/conf/yarn-site.xml root@tiger:/etc/hadoop/conf/
  scp /etc/hadoop/conf/yarn-site.xml root@horse:/etc/hadoop/conf/
  scp /etc/hadoop/conf/yarn-site.xml root@monkey:/etc/hadoop/conf/
  scp /etc/hadoop/conf/mapred-site.xml root@tiger:/etc/hadoop/conf/
  scp /etc/hadoop/conf/mapred-site.xml root@horse:/etc/hadoop/conf/
  scp /etc/hadoop/conf/mapred-site.xml root@monkey:/etc/hadoop/conf/
  scp /etc/hadoop/conf/hadoop-env.sh root@tiger:/etc/hadoop/conf/
  scp /etc/hadoop/conf/hadoop-env.sh root@horse:/etc/hadoop/conf/
  scp /etc/hadoop/conf/hadoop-env.sh root@monkey:/etc/hadoop/conf/
}

MYHOST="`hostname`: "
echo 
echo $MYHOST "Running " $0"."
copyConfigFiles
echo 
echo $MYHOST $0 "done."
