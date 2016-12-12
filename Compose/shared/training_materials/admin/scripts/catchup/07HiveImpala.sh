#!/bin/bash

installConfigureAndStartZookeeper(){
  echo
  echo "Installing ZooKeeper on elephant, tiger, and horse."
  echo
  sudo yum --assumeyes install zookeeper-server
  ssh training@tiger sudo yum --assumeyes install zookeeper-server
  ssh training@horse sudo yum --assumeyes install zookeeper-server
  echo
  echo "Initializing the ZooKeeper instances."
  echo
  sudo service zookeeper-server init --myid 1
  ssh training@tiger sudo service zookeeper-server init --myid 2
  ssh training@horse sudo service zookeeper-server init --myid 3
  echo
  echo "Configuring ZooKeeper."
  echo
  sudo cp /home/training/training_materials/admin/scripts/catchup/07HiveImpala.Baseconfig/zoo.cfg /etc/zookeeper/conf
  sudo cp /home/training/training_materials/admin/scripts/catchup/07HiveImpala.Baseconfig/java.env /etc/zookeeper/conf
  echo
  echo "Copying the updated HDFS configuration to tiger, horse, and monkey."
  echo
  scp /etc/zookeeper/conf/zoo.cfg root@tiger:/etc/zookeeper/conf
  scp /etc/zookeeper/conf/zoo.cfg root@horse:/etc/zookeeper/conf
  scp /etc/zookeeper/conf/java.env root@tiger:/etc/zookeeper/conf
  scp /etc/zookeeper/conf/java.env root@horse:/etc/zookeeper/conf
  echo
  echo "Starting Zookeeper on elephant, tiger, and horse."
  echo
  sudo service zookeeper-server start
  ssh training@tiger sudo service zookeeper-server start
  ssh training@horse sudo service zookeeper-server start
  echo
}

installAndConfigureHive() {
  echo
  echo "Installing Hive on elephant."
  echo
  sudo yum install --assumeyes hive
  echo
  echo "Configuring Hive."
  echo
  echo
  echo "Putting elephant's IP address in hive.metastore.uris in hive-site.xml."
  echo "Either an IP address or FQHN is required."
  echo
  IP_ADDRESS=`cat /etc/hosts | grep elephant | awk '{print $1}'`
  sed -i s/elephant:9083/$IP_ADDRESS:9083/ /home/training/training_materials/admin/scripts/catchup/07HiveImpala.Baseconfig/hive-site.xml
  sudo cp /home/training/training_materials/admin/scripts/catchup/07HiveImpala.Baseconfig/hive-site.xml /etc/hive/conf/
  echo 
  echo "Creating HDFS directories needed by Hive"
  echo 
  sudo -u hdfs hadoop fs -mkdir -p /user/hive/warehouse
  sudo -u hdfs hadoop fs -chmod 1777 /user/hive/warehouse
  echo 
  echo "Creating a link to the MySQL JDBC driver in the /usr/lib/hive/lib directory."
  echo 
  sudo ln -s /usr/share/java/mysql-connector-java.jar /usr/lib/hive/lib/
}

createMetastoreDB() {
  echo 
  echo "Creating the Hive Metastore database." 
  echo 
  mysql -u root --password= -h localhost -e "CREATE DATABASE metastore"  
  mysql -u root --password= -h localhost metastore -e "CREATE USER 'hiveuser'@'%' IDENTIFIED BY 'password'"  
  mysql -u root --password= -h localhost metastore -e "REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'hiveuser'@'%'"  
  mysql -u root --password= -h localhost metastore -e "GRANT SELECT,INSERT,UPDATE,DELETE,LOCK TABLES,EXECUTE,CREATE,ALTER ON metastore.* TO 'hiveuser'@'%'"  
  sudo /usr/lib/hive/bin/schematool -dbType mysql -initSchema
  mysql -u root --password= -h localhost metastore -e "REVOKE ALTER,CREATE ON metastore.* FROM 'hiveuser'@'%'"  
  mysql -u root --password= -h localhost metastore -e "SHOW tables"  
}

installAndStartMetastoreService() {
  echo 
  echo "Installing and starting the Hive Metastore service on elephant." 
  echo 
  sudo yum install --assumeyes hive-metastore
  sudo service hive-metastore start
}

installConfigureAndStartHiveServer2() {
  echo
  echo "Installing and configuring HiveServer2."
  echo
  sudo yum install --assumeyes hive-server2
  sudo cp /home/training/training_materials/admin/scripts/catchup/07HiveImpala.Baseconfig/hive-server2 /etc/default
  echo
  echo "Starting HiveServer2."
  echo
  sudo service hive-server2 start
}

configureHDFS() {
  echo 
  echo "Configuring HDFS to improve Impala performance."
  echo 
  sudo cp /home/training/training_materials/admin/scripts/catchup/07HiveImpala.Baseconfig/hdfs-site.xml /etc/hadoop/conf
  echo 
  echo "Copying the updated HDFS configuration to tiger, horse, and monkey."
  echo 
  scp /etc/hadoop/conf/hdfs-site.xml root@tiger:/etc/hadoop/conf/
  scp /etc/hadoop/conf/hdfs-site.xml root@horse:/etc/hadoop/conf/
  scp /etc/hadoop/conf/hdfs-site.xml root@monkey:/etc/hadoop/conf/
  echo 
  echo "Restarting all four DataNodes."
  echo 
  sudo service hadoop-hdfs-datanode restart
  ssh training@tiger sudo service hadoop-hdfs-datanode restart
  ssh training@horse sudo service hadoop-hdfs-datanode restart
  ssh training@monkey sudo service hadoop-hdfs-datanode restart
}

installImpala() {
  echo 
  echo "Installing Impala."
  echo 
  echo
  echo "Impala State Store Server: horse"
  echo
  ssh training@horse sudo yum install --assumeyes impala-state-store
  echo
  echo "Impala Catalog Server: horse"
  echo
  ssh training@horse sudo yum install --assumeyes impala-catalog
  echo
  echo "Impala Server: all four hosts" 
  echo 
  sudo yum install --assumeyes impala-server
  ssh training@tiger sudo yum install --assumeyes impala-server
  ssh training@horse sudo yum install --assumeyes impala-server
  ssh training@monkey sudo yum install --assumeyes impala-server
}

configureImpala() {
  echo 
  echo "Configuring Impala on elephant."
  echo
  echo 
  echo "Copying the configuration files to /etc/impala/conf."
  echo
  sudo cp /home/training/training_materials/admin/scripts/catchup/07HiveImpala.Baseconfig/impala /etc/default/impala
  sudo cp /etc/hive/conf/hive-site.xml /etc/impala/conf
  sudo cp /etc/hadoop/conf/core-site.xml /etc/impala/conf
  sudo cp /etc/hadoop/conf/hdfs-site.xml /etc/impala/conf
  sudo cp /etc/hadoop/conf/log4j.properties /etc/impala/conf
  echo 
  echo "Copying the Impala configuration to tiger, horse, and monkey."
  echo 
  scp /etc/default/impala root@tiger:/etc/default/
  scp /etc/default/impala root@horse:/etc/default/
  scp /etc/default/impala root@monkey:/etc/default/
  scp /etc/impala/conf/core-site.xml root@tiger:/etc/impala/conf/
  scp /etc/impala/conf/core-site.xml root@horse:/etc/impala/conf/
  scp /etc/impala/conf/core-site.xml root@monkey:/etc/impala/conf/
  scp /etc/impala/conf/hdfs-site.xml root@tiger:/etc/impala/conf/
  scp /etc/impala/conf/hdfs-site.xml root@horse:/etc/impala/conf/
  scp /etc/impala/conf/hdfs-site.xml root@monkey:/etc/impala/conf/
  scp /etc/impala/conf/log4j.properties root@tiger:/etc/impala/conf/
  scp /etc/impala/conf/log4j.properties root@horse:/etc/impala/conf/
  scp /etc/impala/conf/log4j.properties root@monkey:/etc/impala/conf/
  scp /etc/impala/conf/hive-site.xml root@tiger:/etc/impala/conf/
  scp /etc/impala/conf/hive-site.xml root@horse:/etc/impala/conf/
  scp /etc/impala/conf/hive-site.xml root@monkey:/etc/impala/conf/
}  

startImpala() {
  echo 
  echo "Starting the Impala State Store daemon on horse."
  echo 
  ssh training@horse sudo service impala-state-store start
  echo 
  echo "Starting the Impala Catalog daemon on horse."
  echo 
  ssh training@horse sudo service impala-catalog start
  echo 
  echo "Starting the Impala Server on all four hosts."
  echo 
  sudo service impala-server start 
  ssh training@tiger sudo service impala-server start
  ssh training@horse sudo service impala-server start
  ssh training@monkey sudo service impala-server start
}

showImpalaProcesses(){
  echo 
  echo "The following Impala processes are running:" 
  echo 
  echo 
  echo "elephant:" 
  echo 
  ps -ef | grep impala 
  echo 
  echo "tiger:" 
  echo 
  ssh training@tiger 'ps -ef | grep impala'
  echo 
  echo "horse:" 
  echo 
  ssh training@horse 'ps -ef | grep impala'
  echo 
  echo "monkey:" 
  echo 
  ssh training@monkey 'ps -ef | grep impala'
}

runQueries() {
  echo 
  echo "Importing the movierating table into Hadoop using Sqoop."
  echo 
  sqoop import --connect jdbc:mysql://localhost/movielens --table movierating --fields-terminated-by '\t' --username training --password training
  echo 
  echo "Defining the movierating table in Hive."
  echo 
  beeline -u jdbc:hive2://elephant:10000 -n training -e "CREATE EXTERNAL TABLE movierating (userid INT, movieid INT, rating TINYINT) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' LOCATION '/user/training/movierating'"
  echo 
  echo "Running a query on Hive."
  echo 
  beeline -u jdbc:hive2://elephant:10000 -n training -e "SELECT COUNT(*) FROM movierating"
  echo
  echo "Installing the Impala shell."
  echo
  sudo yum install --assumeyes impala-shell
  echo
  echo "Running queries on Impala."
  echo
  impala-shell -i horse -q "INVALIDATE METADATA"
  impala-shell -i horse -q "SELECT COUNT(*) FROM movierating"
}

MYHOST="`hostname`: "
echo 
echo $MYHOST "Running " $0"."
installConfigureAndStartZookeeper
installAndConfigureHive
createMetastoreDB
installAndStartMetastoreService
installConfigureAndStartHiveServer2
configureHDFS
installImpala
configureImpala
startImpala
showImpalaProcesses
runQueries
echo 
echo $MYHOST $0 "done."
