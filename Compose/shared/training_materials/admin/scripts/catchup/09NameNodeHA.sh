#!/bin/bash

saveCurrentConfiguration() {
  echo "Saving off the current Hadoop configuration in case of problems."
  mkdir /home/training/backup_config
  cp /etc/hadoop/conf/* /home/training/backup_config/
}

stopHueImpalaHttpFS() {
  echo 
  echo "Stopping a number of daemons that will no longer be used."
  echo
  echo "Stopping the Hive Metastore service daemons."
  echo
  sudo service hive-metastore stop
  echo
  echo "Stopping HiveServer2."
  echo
  sudo service hive-server2 stop
  echo
  echo "Stopping the Impala daemons."
  echo 
  sudo service impala-server stop
  ssh training@tiger sudo service impala-server stop
  ssh training@horse sudo service impala-server stop
  ssh training@monkey sudo service impala-server stop
  ssh training@horse sudo service impala-catalog stop
  ssh training@horse sudo service impala-state-store stop
  echo
  echo "Stopping the Hue and HttpFS daemons."
  echo
  ssh training@monkey sudo service hadoop-httpfs stop
  ssh training@monkey sudo service hue stop
}

stopHDFSDaemons() {
  echo 
  echo "Stopping the SecondaryNameNode and NameNode services on tiger and elephant."
  echo 
  ssh training@tiger 'sudo service hadoop-hdfs-secondarynamenode stop'
  sudo service hadoop-hdfs-namenode stop
  echo 
  echo "Stopping the DataNode on all four hosts in the cluster."
  echo 
  echo "Stopping the DataNode on elephant."
  echo 
  sudo service hadoop-hdfs-datanode stop
  echo 
  echo "Stopping the DataNode on tiger."
  echo 
  ssh training@tiger 'sudo service hadoop-hdfs-datanode stop'
  echo 
  echo "Stopping the DataNode on horse."
  echo 
  ssh training@horse 'sudo service hadoop-hdfs-datanode stop'
  echo 
  echo "Stopping the DataNode on monkey."
  echo 
  ssh training@monkey 'sudo service hadoop-hdfs-datanode stop'
}

copyBaseConfigurationFiles() {
  echo 
  echo "Copying the HA configuration to all the hosts in your cluster."
  echo 
  sudo cp /home/training/training_materials/admin/scripts/catchup/09NameNodeHA.Baseconfig/* /etc/hadoop/conf/
  scp /home/training/training_materials/admin/scripts/catchup/09NameNodeHA.Baseconfig/* root@tiger:/etc/hadoop/conf/
  scp /home/training/training_materials/admin/scripts/catchup/09NameNodeHA.Baseconfig/* root@horse:/etc/hadoop/conf/
  scp /home/training/training_materials/admin/scripts/catchup/09NameNodeHA.Baseconfig/* root@monkey:/etc/hadoop/conf/
}

installJournalNodeSoftware() {
  echo 
  echo "Installing the journal node software on elephant." 
  echo 
  sudo yum install --assumeyes hadoop-hdfs-journalnode
  echo 
  echo "Installing the journal node software on tiger." 
  echo 
  ssh training@tiger 'sudo yum install --assumeyes hadoop-hdfs-journalnode'
  echo 
  echo "Installing the journal node software on horse." 
  echo 
  ssh training@horse 'sudo yum install --assumeyes hadoop-hdfs-journalnode'
}

startJournalNodes() {
  echo 
  echo "Starting the journal node on elephant." 
  echo 
  sudo mkdir -p /disk1/dfs/jn
  sudo chown -R hdfs:hadoop /disk1/dfs/jn
  sudo service hadoop-hdfs-journalnode start
  echo 
  echo "Starting the journal node on tiger." 
  echo 
  ssh training@tiger 'sudo mkdir -p /disk1/dfs/jn'
  ssh training@tiger 'sudo chown -R hdfs:hadoop /disk1/dfs/jn'
  ssh training@tiger 'sudo service hadoop-hdfs-journalnode start'
  echo 
  echo "Starting the journal node on horse." 
  echo 
  ssh training@horse 'sudo mkdir -p /disk1/dfs/jn'
  ssh training@horse 'sudo chown -R hdfs:hadoop /disk1/dfs/jn'
  ssh training@horse 'sudo service hadoop-hdfs-journalnode start'
}

initializeSharedEditsAndStartPrimary() {
  echo 
  echo "Initializing the shared edits directory on elephant."
  echo "This step is required when converting a non-HA configuration to an HA configuration."
  echo 
  sudo -u hdfs hdfs namenode -initializeSharedEdits
  echo 
  echo "Starting the primary NameNode on elephant." 
  echo 
  sudo service hadoop-hdfs-namenode start
}

installBootstrapAndStartStandbyNameNode() {
  echo 
  echo "Installing the standby NameNode software on tiger." 
  echo 
  ssh training@tiger sudo yum install --assumeyes hadoop-hdfs-namenode
  echo 
  echo "Bootstrapping the standby NameNode on tiger." 
  echo "This step copies the metadata from the primary NameNode to the standby."
  echo 
  ssh training@tiger 'sudo -u hdfs hdfs namenode -bootstrapStandby'
  echo 
  echo "Starting the standby NameNode on tiger." 
  echo 
  ssh training@tiger 'sudo service hadoop-hdfs-namenode start'
}

installFormatAndStartZKFC(){
  echo 
  echo "Installing the Zookeeper Failover Controller software on elephant." 
  echo 
  sudo yum install --assumeyes hadoop-hdfs-zkfc
  echo 
  echo "Installing the Zookeeper Failover Controller software on tiger." 
  echo 
  ssh training@tiger 'sudo yum install --assumeyes hadoop-hdfs-zkfc'
  echo 
  echo "Formatting the Zookeeper Failover Controller on elephant." 
  echo 
  sudo -u hdfs hdfs zkfc -formatZK
  echo 
  echo "Starting the Zookeeper Failover Controller software on elephant." 
  echo 
  sudo service hadoop-hdfs-zkfc start
  echo 
  echo "Starting the Zookeeper Failover Controller software on tiger." 
  echo 
  ssh training@tiger 'sudo service hadoop-hdfs-zkfc start'
}

startDataNodes(){
  echo 
  echo "Starting the DataNode on all four hosts in the cluster."
  echo 
  echo "Starting the DataNode on elephant."
  echo 
  sudo service hadoop-hdfs-datanode start
  echo 
  echo "Starting the DataNode on tiger."
  echo 
  ssh training@tiger 'sudo service hadoop-hdfs-datanode start'
  echo 
  echo "Starting the DataNode on horse."
  echo 
  ssh training@horse 'sudo service hadoop-hdfs-datanode start'
  echo 
  echo "Starting the DataNode on monkey."
  echo 
  ssh training@monkey 'sudo service hadoop-hdfs-datanode start'
}

restartMR(){
  echo 
  echo "Restarting the YARN and MapReduce daemons."
  echo 
  echo "Restarting the ResourceManager on horse."
  echo 
  ssh training@horse 'sudo service hadoop-yarn-resourcemanager restart'

  echo 
  echo "Restarting the HistoryServer on monkey."
  echo 
  ssh training@monkey 'sudo service hadoop-mapreduce-historyserver restart'
  echo 
  echo "Restarting the NodeManager on elephant."
  echo 
  sudo service hadoop-yarn-nodemanager restart
  echo 
  echo "Restarting the NodeManager on tiger."
  echo 
  ssh training@tiger 'sudo service hadoop-yarn-nodemanager restart'
  echo 
  echo "Restarting the NodeManager on horse."
  echo 
  ssh training@horse 'sudo service hadoop-yarn-nodemanager restart'
  echo 
  echo "Restarting the NodeManager on monkey."
  echo 
  ssh training@monkey 'sudo service hadoop-yarn-nodemanager restart'
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

getServiceStates(){
  echo 
  echo "Querying service state for NameNode nn1 (elephant)." 
  echo 
  sudo -u hdfs hdfs haadmin -getServiceState nn1
  echo 
  echo "Querying service state for NameNode nn2 (tiger)." 
  echo 
  sudo -u hdfs hdfs haadmin -getServiceState nn2
}

MYHOST="`hostname`: "
echo 
echo $MYHOST "Running " $0"."
saveCurrentConfiguration
stopHueImpalaHttpFS
stopHDFSDaemons
copyBaseConfigurationFiles
installJournalNodeSoftware
startJournalNodes
initializeSharedEditsAndStartPrimary
installBootstrapAndStartStandbyNameNode
installFormatAndStartZKFC
startDataNodes
restartMR
showProcesses
getServiceStates
echo 
echo $MYHOST $0 "done."
