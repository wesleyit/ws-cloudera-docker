#!/bin/bash

installAndStartHttpFS() {
  echo 
  echo "Installing HttpFS on monkey." 
  echo 
  ssh training@monkey sudo yum install --assumeyes hadoop-httpfs
  echo 
  echo "Starting HttpFS on monkey." 
  echo 
  ssh training@monkey 'sudo service hadoop-httpfs start'
}

configureHttpFSProxyUser() {
  echo 
  echo "Configuring the httpfs user as a proxy user on Hadoop." 
  echo 
  sudo cp /home/training/training_materials/admin/scripts/catchup/08Hue.Baseconfig/*.xml /etc/hadoop/conf/
  scp /home/training/training_materials/admin/scripts/catchup/08Hue.Baseconfig/*.xml root@tiger:/etc/hadoop/conf/
  scp /home/training/training_materials/admin/scripts/catchup/08Hue.Baseconfig/*.xml root@horse:/etc/hadoop/conf/
  scp /home/training/training_materials/admin/scripts/catchup/08Hue.Baseconfig/*.xml root@monkey:/etc/hadoop/conf/
  echo 
  echo "Restarting the name node on elephant." 
  echo 
  sudo service hadoop-hdfs-namenode restart
}

installAndConfigureHue() {
  echo 
  echo "Installing Hue."
  echo 
  ssh training@monkey 'sudo yum install --assumeyes hue'
  echo
  echo "Configuring Hue."
  echo 
  ssh training@monkey 'sudo cp /home/training/training_materials/admin/scripts/catchup/08Hue.Baseconfig/hue.ini /etc/hue/conf/'
}

configureHive() {
  echo 
  echo "Configuring Hive on monkey so that Hue can run Hive queries."
  echo 
  ssh training@monkey sudo ln -s /usr/share/java/mysql-connector-java.jar /usr/lib/hive/lib/
  scp /etc/hive/conf/hive-site.xml root@monkey:/etc/hive/conf/
}

setUpUsersInHue() {
  echo 
  echo "Prepopulate Hue with users (admin and fred) and a group (analysts)."
  echo 
  ssh training@monkey 'sudo sqlite3 /var/lib/hue/desktop.db < /home/training/training_materials/admin/scripts/catchup/08Hue.Baseconfig/initHue.sql'
  echo 
  echo "Create home directories for admin and fred in HDFS."
  echo 
  sudo -u hdfs hadoop fs -mkdir /user/admin
  sudo -u hdfs hadoop fs -chown admin:admin /user/admin
  sudo -u hdfs hadoop fs -mkdir /user/fred
  sudo -u hdfs hadoop fs -chown fred:fred /user/fred
}

startHue() {
  echo 
  echo "Starting the Hue server."
  echo 
  ssh training@monkey 'sudo service hue start'
  echo 
  echo "The following processes are running on monkey:" 
  echo 
  ssh training@monkey 'sudo jps'
}

runWordCount() {
  echo 
  echo "Running WordCount to create a JobTracker entry for the Hue Job Browser."
  echo 
  hadoop jar /usr/lib/hadoop-mapreduce/hadoop-mapreduce-examples.jar wordcount elephant/shakespeare test_output_for_hue
}

showProcesses(){
  echo 
  echo "The following processes are running on elephant:" 
  echo 
  sudo jps
  echo 
  echo "The following processes are running on tiger:" 
  echo 
  ssh training@tiger 'sudo jps'
  echo 
  echo "The following processes are running on horse:" 
  echo 
  ssh training@horse 'sudo jps'
  echo 
  echo "The following processes are running on monkey:" 
  echo 
  ssh training@monkey 'sudo jps'
}

showHueProcesses(){
  echo 
  echo "The following python processes are running on monkey:" 
  echo 
  ssh training@monkey 'ps -ef | grep python'
}

MYHOST="`hostname`: "
echo 
echo $MYHOST "Running " $0"."
installAndStartHttpFS
configureHttpFSProxyUser
installAndConfigureHue
configureHive
setUpUsersInHue
startHue
runWordCount
showProcesses
showHueProcesses
echo 
echo $MYHOST $0 "done."
