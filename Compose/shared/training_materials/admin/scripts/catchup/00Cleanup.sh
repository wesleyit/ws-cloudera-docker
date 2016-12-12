#!/bin/bash

killAllProcessesOnOneNode() {
  $1 sudo service cloudera-scm-agent hard_stop
  $1 sudo service cloudera-scm-server stop
  $1 sudo service cloudera-scm-server-db stop
  $1 sudo service hadoop-hdfs-datanode stop
  $1 sudo service hadoop-hdfs-namenode stop
  $1 sudo service hadoop-hdfs-secondarynamenode stop
  $1 sudo service hadoop-hdfs-journalnode stop
  $1 sudo service hadoop-hdfs-zkfc stop
  $1 sudo service hadoop-yarn-resourcemanager stop
  $1 sudo service hadoop-yarn-nodemanager stop
  $1 sudo service hadoop-mapreduce-historyserver stop
  $1 sudo service hadoop-0.20-mapreduce-jobtracker stop
  $1 sudo service hadoop-0.20-mapreduce-tasktracker stop
  $1 sudo service hive-server2 stop
  $1 sudo service hive-webhcat-server stop
  $1 sudo service hue stop
  $1 sudo service impala-catalog stop
  $1 sudo service impala-state-store stop
  $1 sudo service impala-server stop
  $1 sudo service llama stop
  $1 sudo service oozie stop
  $1 sudo service solr-server stop
  $1 sudo service zookeeper-server stop
}

killAllProcessesOnAllNodes() {
  echo 
  echo "Killing all active Hadoop and ecosystem processes on elephant."
  echo 
  killAllProcessesOnOneNode "" 

  echo 
  echo "Killing all active Hadoop and ecosystem processes on tiger."
  echo 
  killAllProcessesOnOneNode "ssh training@tiger"

  echo 
  echo "Killing all active Hadoop and ecosystem processes on horse."
  echo 
  killAllProcessesOnOneNode "ssh training@horse"

  echo 
  echo "Killing all active Hadoop and ecosystem processes on monkey."
  echo 
  killAllProcessesOnOneNode "ssh training@monkey"

  if [ "$1" == "CM" ] 
  then 
    echo 
    echo "Killing all active Hadoop and ecosystem processes on lion."
    echo 
    killAllProcessesOnOneNode "ssh training@lion"
  fi
}

unmountTmpfs() {
if [ "$1" == "CM" ]
  then
    echo
    echo "Unmounting tmpfs on elephant, tiger, horse, monkey, and lion."
    echo
    sudo umount /var/run/cloudera-scm-agent/process
    ssh training@tiger sudo umount /var/run/cloudera-scm-agent/process
    ssh training@horse sudo umount /var/run/cloudera-scm-agent/process
    ssh training@monkey sudo umount /var/run/cloudera-scm-agent/process
    ssh training@lion sudo umount /var/run/cloudera-scm-agent/process
  fi
}

uninstallRPMsOnOneNode() {
  $1 sudo yum remove --assumeyes avro*
  $1 sudo yum remove --assumeyes crunch*
  $1 sudo yum remove --assumeyes cloudera*
  $1 sudo yum remove --assumeyes impala*
  $1 sudo yum remove --assumeyes sqoop*
  $1 sudo yum remove --assumeyes flume*
  $1 sudo yum remove --assumeyes pig*
  $1 sudo yum remove --assumeyes hbase*
  $1 sudo yum remove --assumeyes hive*
  $1 sudo yum remove --assumeyes hue*
  $1 sudo yum remove --assumeyes bigtop*
  $1 sudo yum remove --assumeyes oozie*
  $1 sudo yum remove --assumeyes llama*
  $1 sudo yum remove --assumeyes solr*
  $1 sudo yum remove --assumeyes zookeeper*
  $1 sudo yum remove --assumeyes hadoop*
  $1 sudo yum remove --assumeyes spark*
  $1 sudo yum clean all
}

uninstallRPMsOnAllNodes() {
  echo 
  echo "Uninstalling all Hadoop and ecosystem RPMs on elephant."
  echo 
  uninstallRPMsOnOneNode "" 

  echo 
  echo "Uninstalling all Hadoop and ecosystem RPMs on tiger."
  echo 
  uninstallRPMsOnOneNode "ssh training@tiger"

  echo 
  echo "Uninstalling all Hadoop and ecosystem RPMs on horse."
  echo 
  uninstallRPMsOnOneNode "ssh training@horse"

  echo 
  echo "Uninstalling all Hadoop and ecosystem RPMs on monkey."
  echo 
  uninstallRPMsOnOneNode "ssh training@monkey"

  if [ "$1" == "CM" ] 
  then 
    echo 
    echo "Uninstalling all Hadoop and ecosystem RPMs on lion."
    echo 
    uninstallRPMsOnOneNode "ssh training@lion"
  fi
}

deleteFilesOnOneNode() {
  $1 sudo rm -rf /disk1
  $1 sudo rm -rf /disk2
  $1 sudo rm -rf /dfs
  $1 sudo rm -rf /mapred
  $1 sudo rm -rf /etc/cloudera*
  $1 sudo rm -rf /etc/default/impala
  $1 sudo rm -rf /etc/flume-ng
  $1 sudo rm -rf /etc/hadoop
  $1 sudo rm -rf /etc/hbase*
  $1 sudo rm -rf /etc/hive*
  $1 sudo rm -rf /etc/hue
  $1 sudo rm -rf /etc/impala
  $1 sudo rm -rf /etc/llama
  $1 sudo rm -rf /etc/oozie
  $1 sudo rm -rf /etc/pig
  $1 sudo rm -rf /etc/solr
  $1 sudo rm -rf /etc/spark
  $1 sudo rm -rf /etc/sqoop*
  $1 sudo rm -rf /etc/zookeeper
  $1 sudo rm -rf /etc/alternatives/flume*
  $1 sudo rm -rf /etc/alternatives/hadoop*
  $1 sudo rm -rf /etc/alternatives/hbase*
  $1 sudo rm -rf /etc/alternatives/hive*
  $1 sudo rm -rf /etc/alternatives/hue*
  $1 sudo rm -rf /etc/alternatives/impala*
  $1 sudo rm -rf /etc/alternatives/llama*
  $1 sudo rm -rf /etc/alternatives/oozie*
  $1 sudo rm -rf /etc/alternatives/pig*
  $1 sudo rm -rf /etc/alternatives/solr*
  $1 sudo rm -rf /etc/alternatives/spark*
  $1 sudo rm -rf /etc/alternatives/sqoop*
  $1 sudo rm -rf /etc/alternatives/zookeeper*
  $1 sudo rm -rf /home/training/backup_config
  $1 sudo rm -rf /tmp/*scm*
  $1 sudo rm -rf /tmp/.*scm*
  $1 sudo rm -rf /tmp/hadoop*
  $1 sudo rm -rf /var/cache/yum/cloudera*
  $1 sudo rm -rf /usr/lib/hadoop*
  $1 sudo rm -rf /usr/lib/hive*
  $1 sudo rm -rf /usr/lib/hue
  $1 sudo rm -rf /usr/lib/oozie
  $1 sudo rm -rf /usr/lib/parquet
  $1 sudo rm -rf /usr/lib/spark
  $1 sudo rm -rf /usr/lib/sqoop
  $1 sudo rm -rf /usr/share/cmf
  $1 sudo rm -rf /usr/share/hue
  $1 sudo rm -rf /var/lib/cloudera*
  $1 sudo rm -rf /var/lib/flume-ng
  $1 sudo rm -rf /var/lib/hadoop*
  $1 sudo rm -rf /var/lib/hdfs
  $1 sudo rm -rf /var/lib/hive*
  $1 sudo rm -rf /var/lib/hue
  $1 sudo rm -rf /var/lib/impala
  $1 sudo rm -rf /var/lib/oozie
  $1 sudo rm -rf /var/lib/sqoop*
  $1 sudo rm -rf /var/lib/spark
  $1 sudo rm -rf /var/lib/solr
  $1 sudo rm -rf /var/lib/zookeeper
  $1 sudo rm -rf /var/lib/alternatives/flume*
  $1 sudo rm -rf /var/lib/alternatives/hadoop*
  $1 sudo rm -rf /var/lib/alternatives/hbase*
  $1 sudo rm -rf /var/lib/alternatives/hive*
  $1 sudo rm -rf /var/lib/alternatives/hue*
  $1 sudo rm -rf /var/lib/alternatives/impala*
  $1 sudo rm -rf /var/lib/alternatives/llama*
  $1 sudo rm -rf /var/lib/alternatives/oozie*
  $1 sudo rm -rf /var/lib/alternatives/pig*
  $1 sudo rm -rf /var/lib/alternatives/solr*
  $1 sudo rm -rf /var/lib/alternatives/spark*
  $1 sudo rm -rf /var/lib/alternatives/sqoop*
  $1 sudo rm -rf /var/lib/alternatives/zookeeper*
  $1 sudo rm -rf /var/lock/subsys/cloudera*
  $1 sudo rm -rf /var/lock/subsys/flume-ng*
  $1 sudo rm -rf /var/lock/subsys/hadoop*
  $1 sudo rm -rf /var/lock/subsys/hbase*
  $1 sudo rm -rf /var/lock/subsys/hdfs*
  $1 sudo rm -rf /var/lock/subsys/hive*
  $1 sudo rm -rf /var/lock/subsys/hue*
  $1 sudo rm -rf /var/lock/subsys/impala*
  $1 sudo rm -rf /var/lock/subsys/llama*
  $1 sudo rm -rf /var/lock/subsys/oozie*
  $1 sudo rm -rf /var/lock/subsys/solr*
  $1 sudo rm -rf /var/lock/subsys/spark*
  $1 sudo rm -rf /var/lock/subsys/sqoop*
  $1 sudo rm -rf /var/lock/subsys/zookeeper*
  $1 sudo rm -rf /var/log/cloudera*
  $1 sudo rm -rf /var/log/flume-ng
  $1 sudo rm -rf /var/log/hadoop*
  $1 sudo rm -rf /var/log/hbase*
  $1 sudo rm -rf /var/log/hive*
  $1 sudo rm -rf /var/log/hue
  $1 sudo rm -rf /var/log/impala*
  $1 sudo rm -rf /var/log/llama
  $1 sudo rm -rf /var/log/oozie
  $1 sudo rm -rf /var/log/solr
  $1 sudo rm -rf /var/log/sqoop2
  $1 sudo rm -rf /var/log/spark
  $1 sudo rm -rf /var/log/zookeeper
  $1 sudo rm -rf /var/run/cloudera*
  $1 sudo rm -rf /var/run/flume-ng
  $1 sudo rm -rf /var/run/hadoop*
  $1 sudo rm -rf /var/run/hbase*
  $1 sudo rm -rf /var/run/hdfs*
  $1 sudo rm -rf /var/run/hive
  $1 sudo rm -rf /var/run/impala
  $1 sudo rm -rf /var/run/llama
  $1 sudo rm -rf /var/run/oozie
  $1 sudo rm -rf /var/run/solr
  $1 sudo rm -rf /var/run/spark
  $1 sudo rm -rf /var/run/sqoop2
  $1 sudo rm -rf /var/run/zookeeper
  $1 sudo rm -rf /yarn
}

deleteFilesOnAllNodes() {
  echo 
  echo "Deleting files on elephant."
  echo 
  deleteFilesOnOneNode "" 

  echo 
  echo "Deleting files on tiger."
  echo 
  deleteFilesOnOneNode "ssh training@tiger"

  echo 
  echo "Deleting files on horse."
  echo 
  deleteFilesOnOneNode "ssh training@horse"

  echo 
  echo "Deleting files on monkey."
  echo 
  deleteFilesOnOneNode "ssh training@monkey"

  if [ "$1" == "CM" ]
  then
    echo 
    echo "Deleting files on lion."
    echo 
    deleteFilesOnOneNode "ssh training@lion"
  fi
}

deleteHadoopUsersAndGroupsOnOneNode() {
  $1 sudo /usr/sbin/userdel flume
  $1 sudo /usr/sbin/userdel hbase
  $1 sudo /usr/sbin/userdel hdfs
  $1 sudo /usr/sbin/userdel hive
  $1 sudo /usr/sbin/userdel hue
  $1 sudo /usr/sbin/userdel httpfs
  $1 sudo /usr/sbin/userdel impala
  $1 sudo /usr/sbin/userdel llama
  $1 sudo /usr/sbin/userdel mapred
  $1 sudo /usr/sbin/userdel solr
  $1 sudo /usr/sbin/userdel spark
  $1 sudo /usr/sbin/userdel sqoop
  $1 sudo /usr/sbin/userdel sqoop2
  $1 sudo /usr/sbin/userdel yarn
  $1 sudo /usr/sbin/userdel zookeeper
  $1 sudo /usr/sbin/groupdel flume
  $1 sudo /usr/sbin/groupdel hadoop
  $1 sudo /usr/sbin/groupdel hbase
  $1 sudo /usr/sbin/groupdel hdfs
  $1 sudo /usr/sbin/groupdel hive
  $1 sudo /usr/sbin/groupdel hue
  $1 sudo /usr/sbin/groupdel httpfs
  $1 sudo /usr/sbin/groupdel impala
  $1 sudo /usr/sbin/groupdel llama
  $1 sudo /usr/sbin/groupdel mapred
  $1 sudo /usr/sbin/groupdel solr
  $1 sudo /usr/sbin/groupdel spark
  $1 sudo /usr/sbin/groupdel sqoop
  $1 sudo /usr/sbin/groupdel sqoop2
  $1 sudo /usr/sbin/groupdel yarn
  $1 sudo /usr/sbin/groupdel zookeeper
}

deleteHadoopUsersAndGroupsOnAllNodes() {
  echo
  echo "Deleting users and groups created by Hadoop installers"
  echo "on elephant, tiger, horse, and monkey."
  echo
  deleteHadoopUsersAndGroupsOnOneNode ""
  deleteHadoopUsersAndGroupsOnOneNode "ssh training@tiger"
  deleteHadoopUsersAndGroupsOnOneNode "ssh training@horse"
  deleteHadoopUsersAndGroupsOnOneNode "ssh training@monkey"

  if [ "$1" == "CM" ]
  then
    echo
    echo "Deleting users and groups created by Hadoop installers on lion."
    echo
    deleteHadoopUsersAndGroupsOnOneNode "ssh training@lion"
  fi
}

deleteMetastoreDB() {
  echo
  echo "Delete hiveuser and the Hive Metastore database from MySQL."
  echo
  mysql -u root --password= -h localhost metastore -e "DROP USER 'hiveuser'@'%'"
  mysql -u root --password= -h localhost -e "DROP DATABASE metastore"
}

deleteCMInstallerExceptOnLion() {
  # Avoid accidental installation nodes other than lion
  sudo rm -rf /home/training/software/cloudera-manager-installer.bin
  ssh training@tiger sudo rm -rf /home/training/software/cloudera-manager-installer.bin
  ssh training@horse sudo rm -rf /home/training/software/cloudera-manager-installer.bin
  ssh training@monkey sudo rm -rf /home/training/software/cloudera-manager-installer.bin
}

restoreTestDataOnOneNode() {
  $1 sudo rm -rf /home/training/training_materials/admin/data/shakespeare.txt
  $1 sudo rm -rf /home/training/training_materials/admin/data/shakespeare.txt.gz
  $1 sudo cp /home/training/training_materials/admin/data/shakespeare.txt.gz.orig /home/training/training_materials/admin/data/shakespeare.txt.gz
  $1 sudo chown training:training /home/training/training_materials/admin/data/shakespeare.txt.gz
  $1 sudo rm -rf /home/training/training_materials/admin/data/access_log
  $1 sudo rm -rf /home/training/training_materials/admin/data/access_log.gz
  $1 sudo cp /home/training/training_materials/admin/data/access_log.gz.orig /home/training/training_materials/admin/data/access_log.gz
  $1 sudo chown training:training /home/training/training_materials/admin/data/access_log.gz.orig /home/training/training_materials/admin/data/access_log.gz
  $1 sudo cp /etc/yum.repos.d/cloudera-manager.repo.orig /etc/yum.repos.d/cloudera-manager.repo
}

restoreTestDataOnAllNodes() {
  echo 
  echo "Restoring data on elephant."
  echo 
  restoreTestDataOnOneNode "" 

  echo 
  echo "Restoring data on tiger."
  echo 
  restoreTestDataOnOneNode "ssh training@tiger"

  echo 
  echo "Restoring data on horse."
  echo 
  restoreTestDataOnOneNode "ssh training@horse"

  echo 
  echo "Restoring data on monkey."
  echo 
  restoreTestDataOnOneNode "ssh training@monkey"

  if [ "$1" == "CM" ]
  then
    echo 
    echo "Restoring data on lion."
    echo 
    restoreTestDataOnOneNode "ssh training@lion"
  fi
}

MYHOST="`hostname`: "
echo
echo $MYHOST "Running " $0"."
killAllProcessesOnAllNodes $1
unmountTmpfs $1
uninstallRPMsOnAllNodes $1
deleteFilesOnAllNodes $1
deleteHadoopUsersAndGroupsOnAllNodes $1
deleteMetastoreDB $1
deleteCMInstallerExceptOnLion $1
restoreTestDataOnAllNodes $1
echo 
echo $MYHOST $0 "done."
