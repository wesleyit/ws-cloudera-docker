#!/bin/bash
MYHOST="`hostname`: "
echo 
echo $MYHOST "Running " $0"."
echo 
echo $MYHOST "Installing Flume." 
echo 
sudo yum install --assumeyes flume-ng

echo 
echo $MYHOST "Creating the Flume configuration."
echo 
sudo cp /home/training/training_materials/admin/scripts/catchup/03Flume.Baseconfig/flume-conf.properties /etc/hadoop/conf/flume-conf.properties

echo 
echo $MYHOST "Making the collector1 directory to store the files."
echo 
hadoop fs -mkdir -p flume/collector1
echo 
echo $MYHOST $0 "done."