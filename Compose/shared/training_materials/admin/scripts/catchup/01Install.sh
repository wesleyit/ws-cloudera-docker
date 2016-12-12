#!/bin/bash
MYHOST="`hostname`: "
echo
echo $MYHOST "Running " $0"."
echo

echo
echo "Installing Hadoop in pseudo-distributed mode" 
echo 
sudo yum install --assumeyes hadoop-conf-pseudo

echo 
echo "Changing host names in configuration files from localhost to elephant"
echo 
sudo sed -i s/localhost/elephant/g /etc/hadoop/conf/core-site.xml
sudo sed -i s/localhost/elephant/g /etc/hadoop/conf/hdfs-site.xml
sudo sed -i s/localhost/elephant/g /etc/hadoop/conf/mapred-site.xml
sudo sed -i s/localhost/elephant/g /etc/hadoop/conf/yarn-site.xml

echo 
echo $MYHOST "Formatting the NameNode" 
echo 
sudo -u hdfs hdfs namenode -format
 
echo 
echo $MYHOST "Starting the HDFS daemons" 
echo 
sudo service hadoop-hdfs-namenode start
sudo service hadoop-hdfs-secondarynamenode start
sudo service hadoop-hdfs-datanode start

echo
echo $MYHOST "Creating some HDFS directories"
echo 
sudo -u hdfs hadoop fs -mkdir -p /tmp/hadoop-yarn/staging/history/done_intermediate
sudo -u hdfs hadoop fs -chown -R mapred:mapred /tmp/hadoop-yarn/staging
sudo -u hdfs hadoop fs -chmod -R 1777 /tmp
sudo -u hdfs hadoop fs -mkdir -p /var/log/hadoop-yarn
sudo -u hdfs hadoop fs -chown yarn:mapred /var/log/hadoop-yarn

echo 
echo $MYHOST "Starting the YARN and MapReduce daemons" 
echo 
sudo service hadoop-yarn-resourcemanager start
sudo service hadoop-yarn-nodemanager start
sudo service hadoop-mapreduce-historyserver start

echo 
echo $MYHOST "Creating an HDFS directory for the training user" 
echo 
sudo -u hdfs hadoop fs -mkdir -p /user/training
sudo -u hdfs hadoop fs -chown training /user/training

echo 
echo $MYHOST "Verifying all six daemons are running"
echo 
sudo jps

echo 
echo $MYHOST "Copying shakespeare.txt file to HDFS"
echo 
cd ~/training_materials/admin/data
gunzip shakespeare.txt.gz
hadoop fs -mkdir input
hadoop fs -put shakespeare.txt input
 
echo 
echo $MYHOST $0 "done."
