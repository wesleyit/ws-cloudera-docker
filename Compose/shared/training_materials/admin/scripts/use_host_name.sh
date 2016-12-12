#!/bin/bash

changeLocalhost() {
  sudo sed -i s/localhost/elephant/g /etc/hadoop/conf/core-site.xml
  sudo sed -i s/localhost/elephant/g /etc/hadoop/conf/hdfs-site.xml
  sudo sed -i s/localhost/elephant/g /etc/hadoop/conf/mapred-site.xml
}

MYHOST="`hostname`: "
# Avoid "sudo: cannot get working directory" errors by
# changing to a directory owned by the training user
cd ~
echo 
echo $MYHOST "Running " $0"."
changeLocalhost
echo 
echo $MYHOST $0 "done."
