#!/bin/bash

loadLargeFile() {
  echo 
  echo "Loading the access log into the cluster."
  echo 
  gunzip -c ~/training_materials/admin/data/access_log.gz | hadoop fs -put - elephant/access_log
}

stopDataNode() {
  echo 
  echo "Stopping the DataNode on elephant."
  echo 
  sudo service hadoop-hdfs-datanode stop
}

MYHOST="`hostname`: "
echo 
echo $MYHOST "Running " $0"."
loadLargeFile
stopDataNode
echo 
echo $MYHOST $0 "done."
