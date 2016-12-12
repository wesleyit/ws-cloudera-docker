#!/bin/bash

shutDownPseudoDistributedConfiguration() {
  echo 
  echo "Disabling the pseudo-distributed cluster on elephant." 
  echo 
  sudo service hadoop-hdfs-namenode stop
  sudo service hadoop-hdfs-secondarynamenode stop
  sudo service hadoop-hdfs-datanode stop
  sudo service hadoop-yarn-resourcemanager stop
  sudo service hadoop-yarn-nodemanager stop
  sudo service hadoop-mapreduce-historyserver stop
}

removeSNNandRMandHSFromElephant() {
  echo
  echo "Removing SecondaryNameNode software from elephant."
  echo 
  sudo yum remove --assumeyes hadoop-hdfs-secondarynamenode
  echo
  echo "Removing ResourceManager and HistoryServer software from elephant."
  echo
  sudo yum remove --assumeyes hadoop-yarn-resourcemanager
  sudo yum remove --assumeyes hadoop-mapreduce-historyserver
}

installHadoopOnTigerHorseAndMonkey(){
  echo
  echo "Installing SecondaryNameNode software on tiger."
  echo
  ssh training@tiger sudo yum install --assumeyes hadoop-hdfs-secondarynamenode
  echo
  echo "Installing DataNode software on tiger."
  echo 
  ssh training@tiger sudo yum install --assumeyes hadoop-hdfs-datanode
  echo 
  echo "Installing DataNode software on horse."
  echo 
  ssh training@horse sudo yum install --assumeyes hadoop-hdfs-datanode
  echo 
  echo "Installing DataNode software on monkey."
  echo 
  ssh training@monkey sudo yum install --assumeyes hadoop-hdfs-datanode
  echo 
  echo "Installing ResourceManager software on horse."
  echo 
  ssh training@horse sudo yum install --assumeyes hadoop-yarn-resourcemanager
  echo 
  echo "Installing HistoryServer software on monkey."
  echo 
  ssh training@monkey sudo yum install --assumeyes hadoop-mapreduce-historyserver
  echo 
  echo "Installing NodeManager and hadoop-mapreduce software on tiger."
  echo "Also install hadoop-mapreduce, because it includes the mapreduce_shuffler auxiliary service."
  echo "As yarn-site.xml is currently configured, the NodeManager needs this service to start up."
  echo
  ssh training@tiger sudo yum install --assumeyes hadoop-yarn-nodemanager
  ssh training@tiger sudo yum install --assumeyes hadoop-mapreduce
  echo 
  echo "Installing NodeManager and hadoop-mapreduce software on horse."
  echo "Also install hadoop-mapreduce because it includes the mapreduce_shuffler auxiliary service."
  echo "As yarn-site.xml is currently configured, the NodeManager needs this service to start up."
  echo 
  ssh training@horse sudo yum install --assumeyes hadoop-yarn-nodemanager
  ssh training@horse sudo yum install --assumeyes hadoop-mapreduce
  echo
  echo "Installing NodeManager software on monkey."
  echo 
  ssh training@monkey sudo yum install --assumeyes hadoop-yarn-nodemanager
}

copyBaseConfigurationFiles() {
  echo 
  echo "Copying the Hadoop configuration to all the hosts in your cluster."
  echo 
  sudo cp /home/training/training_materials/admin/scripts/catchup/06Cluster.Baseconfig/* /etc/hadoop/conf/
  scp /home/training/training_materials/admin/scripts/catchup/06Cluster.Baseconfig/* root@tiger:/etc/hadoop/conf/
  scp /home/training/training_materials/admin/scripts/catchup/06Cluster.Baseconfig/* root@horse:/etc/hadoop/conf/
  scp /home/training/training_materials/admin/scripts/catchup/06Cluster.Baseconfig/* root@monkey:/etc/hadoop/conf/
}

setUpFileSystemOnOneNode() {
  $1 sudo mkdir -p /disk1/dfs/nn
  $1 sudo mkdir -p /disk2/dfs/nn
  $1 sudo mkdir -p /disk1/dfs/dn
  $1 sudo mkdir -p /disk2/dfs/dn
  $1 sudo mkdir -p /disk1/nodemgr/local
  $1 sudo mkdir -p /disk2/nodemgr/local
  $1 sudo chown -R hdfs:hadoop /disk1/dfs/nn
  $1 sudo chown -R hdfs:hadoop /disk2/dfs/nn
  $1 sudo chown -R hdfs:hadoop /disk1/dfs/dn
  $1 sudo chown -R hdfs:hadoop /disk2/dfs/dn
  $1 sudo chown -R yarn:yarn /disk1/nodemgr/local
  $1 sudo chown -R yarn:yarn /disk2/nodemgr/local
}

setUpFileSystemOnAllNodes() {
  echo 
  echo "Setting up file system directories and permissions on elephant."
  echo 
  setUpFileSystemOnOneNode "" 

  echo 
  echo "Setting up file system directories and permissions on tiger."
  echo 
  setUpFileSystemOnOneNode "ssh training@tiger"

  echo 
  echo "Setting up file system directories and permissions on horse."
  echo 
  setUpFileSystemOnOneNode "ssh training@horse"

  echo 
  echo "Setting up file system directories and permissions on monkey."
  echo 
  setUpFileSystemOnOneNode "ssh training@monkey"
}

formatNameNodeAndStartHDFSDaemons() {
  echo 
  echo "Formatting the NameNode."
  echo 
  sudo -u hdfs hdfs namenode -format

  echo 
  echo "Starting the HDFS daemons."
  echo "Starting the NameNode on elephant."
  echo 
  sudo service hadoop-hdfs-namenode start
  echo 
  echo "Starting the SecondaryNameNode on tiger."
  echo 
  ssh training@tiger 'sudo service hadoop-hdfs-secondarynamenode start'

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

createHDFSPaths(){

  echo 
  echo "Creating the /tmp directory in HDFS."
  echo 
  sudo -u hdfs hadoop fs -mkdir /tmp
  sudo -u hdfs hadoop fs -chmod -R 1777 /tmp

  echo 
  echo "Creating the log directories in HDFS."
  echo 
  sudo -u hdfs hadoop fs -mkdir -p /var/log/hadoop-yarn
  sudo -u hdfs hadoop fs -chown yarn:mapred /var/log/hadoop-yarn

  echo 
  echo "Creating the home directory for the training user."
  echo 
  sudo -u hdfs hadoop fs -mkdir /user
  sudo -u hdfs hadoop fs -mkdir /user/training
  sudo -u hdfs hadoop fs -chown training /user/training

  echo 
  echo "Creating the staging directory."
  echo 
  sudo -u hdfs hadoop fs -mkdir /user/history
  sudo -u hdfs hadoop fs -chmod 1777 /user/history
  sudo -u hdfs hadoop fs -chown mapred:hadoop /user/history
}

startYARNAndMR2Daemons() {
  echo 
  echo "Starting the ResourceManager on horse."
  echo 
  ssh training@horse 'sudo service hadoop-yarn-resourcemanager start'

  echo 
  echo "Starting the HistoryServer on monkey."
  echo 
  ssh training@monkey 'sudo service hadoop-mapreduce-historyserver start'

  echo 
  echo "Starting the NodeManager on elephant."
  echo 
  sudo service hadoop-yarn-nodemanager start
  echo 
  echo "Starting the NodeManager on tiger."
  echo 
  ssh training@tiger 'sudo service hadoop-yarn-nodemanager start'
  echo 
  echo "Starting the NodeManager on horse."
  echo 
  ssh training@horse 'sudo service hadoop-yarn-nodemanager start'
  echo 
  echo "Starting the NodeManager on monkey."
  echo 
  ssh training@monkey 'sudo service hadoop-yarn-nodemanager start'
}

putTestData() {
  $2 hadoop fs -mkdir $1
  $2 hadoop fs -mkdir $1/shakespeare
  $2 hadoop fs -put /home/training/training_materials/admin/data/shakespeare.txt $1/shakespeare/shakespeare.txt
}

runOneSanityTest() {
  $2 hadoop jar /usr/lib/hadoop-mapreduce/hadoop-mapreduce-examples.jar wordcount $1/shakespeare/shakespeare.txt $1/output
  $2 hadoop fs -tail $1/output/part-r-00000
}

runSanityTests() {
  echo 
  echo "Running a sanity test on elephant."
  echo 
  putTestData elephant ""
  runOneSanityTest elephant ""
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

MYHOST="`hostname`: "
echo 
echo $MYHOST "Running " $0"."
shutDownPseudoDistributedConfiguration
removeSNNandRMandHSFromElephant
installHadoopOnTigerHorseAndMonkey
copyBaseConfigurationFiles
setUpFileSystemOnAllNodes
formatNameNodeAndStartHDFSDaemons
createHDFSPaths
startYARNAndMR2Daemons
runSanityTests
showProcesses
echo 
echo $MYHOST $0 "done."
