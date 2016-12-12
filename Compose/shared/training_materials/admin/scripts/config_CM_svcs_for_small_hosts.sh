#!/bin/bash

setSvcConfig(){
  curl -X PUT -H "Content-Type:application/json" -u admin:admin -d @$JSON_PATH/$1 http://lion:7180/api/v6/clusters/Cluster%201/services/$2/roleConfigGroups/$3/config
}

setSvcOverallConfig(){
  curl -X PUT -H "Content-Type:application/json" -u admin:admin -d @$JSON_PATH/$1 http://lion:7180/api/v6/clusters/Cluster%201/services/$2/config
}

setMgmtConfig(){
  curl -X PUT -H "Content-Type:application/json" -u admin:admin -d @$JSON_PATH/$1 http://lion:7180/api/v6/cm/service/roleConfigGroups/$2/config
}

setMgmtOverallConfig(){
  curl -X PUT -H "Content-Type:application/json" -u admin:admin -d @$JSON_PATH/$1 http://lion:7180/api/v6/cm/service/config
}

setHostConfig(){
  curl -X PUT -H "Content-Type:application/json" -u admin:admin -d @$JSON_PATH/$1 http://lion:7180/api/v6/hosts/$2/config
}


runCMRESTAPI(){
  case "$1" in
    default-thresholds)
      setMgmtConfig EventServer.IndexDirectory.json mgmt-EVENTSERVER-BASE
      setMgmtConfig ReportsManager.ScratchDirectory.json mgmt-REPORTSMANAGER-BASE
      setMgmtOverallConfig Mgmt.Database.json
      setSvcConfig NameNode.DataDirectories.json hdfs hdfs-NAMENODE-BASE
      setSvcConfig SecondaryNameNode.CheckpointDirectories.json hdfs hdfs-SECONDARYNAMENODE-BASE
      setSvcConfig DataNode.FreeSpace.json hdfs hdfs-DATANODE-BASE
      setSvcConfig DataNode.FreeSpace.json hdfs hdfs-DATANODE-1
      setSvcConfig DataNode.FreeSpace.json hdfs hdfs-DATANODE-2
      setSvcConfig DataNode.FreeSpace.json hdfs hdfs-DATANODE-3
      setSvcOverallConfig Hdfs.FreeSpace.json hdfs
      setHostConfig Host.ClockOffset.json elephant
      setHostConfig Host.ClockOffset.json tiger
      setHostConfig Host.ClockOffset.json horse
      setHostConfig Host.ClockOffset.json monkey
      setHostConfig Host.ClockOffset.json lion
    ;;
    zookeeper)
      setSvcConfig ZooKeeper.DataDirectory.json zookeeper zookeeper-SERVER-BASE
      setSvcConfig ZooKeeper.DataDirectory.json zookeeper zookeeper-SERVER-1
      setSvcConfig ZooKeeper.DataDirectory.json zookeeper zookeeper-SERVER-2
      setSvcConfig ZooKeeper.DataLogDirectory.json zookeeper zookeeper-SERVER-BASE
      setSvcConfig ZooKeeper.DataLogDirectory.json zookeeper zookeeper-SERVER-1
      setSvcConfig ZooKeeper.DataLogDirectory.json zookeeper zookeeper-SERVER-2
    ;;
    httpfs)
      setSvcConfig HttpFS.HeapSize.json hdfs hdfs-HTTPFS-BASE
    ;;
    mr-client)
      setSvcConfig Yarn.MapperMaxHeapSize.json yarn yarn-GATEWAY-BASE
      setSvcConfig Yarn.ReducerMaxHeapSize.json yarn yarn-GATEWAY-BASE
    ;;
    hdfs-ha)
      setSvcConfig JournalNode.HeapSize.json hdfs hdfs-JOURNALNODE-BASE
      setSvcConfig JournalNode.HeapSize.json hdfs hdfs-JOURNALNODE-1
      setSvcConfig JournalNode.HeapSize.json hdfs hdfs-JOURNALNODE-2
      setSvcConfig JournalNode.EditDirectories.json hdfs hdfs-JOURNALNODE-BASE
      setSvcConfig JournalNode.EditDirectories.json hdfs hdfs-JOURNALNODE-1
      setSvcConfig JournalNode.EditDirectories.json hdfs hdfs-JOURNALNODE-2
      setSvcConfig ZKFC.HeapSize.json hdfs hdfs-FAILOVERCONTROLLER-BASE
      setSvcConfig ZKFC.HeapSize.json hdfs hdfs-FAILOVERCONTROLLER-1
    ;;
    rest-api-examples)
      echo
      echo List role config groups for a service
      echo 
      echo curl -u 'admin:admin' -1 "http://lion:7180/api/v6/clusters/Cluster%201/services/yarn/roleConfigGroups"
      curl -u 'admin:admin' -1 "http://lion:7180/api/v6/clusters/Cluster%201/services/yarn/roleConfigGroups"
      echo
      echo List all the configuration parameters for a role config group
      echo 
      echo curl -u 'admin:admin' -1 "http://lion:7180/api/v6/clusters/Cluster%201/services/hdfs/roleConfigGroups/hdfs-NAMENODE-BASE/config?view=full"
      curl -u 'admin:admin' -1 "http://lion:7180/api/v6/clusters/Cluster%201/services/hdfs/roleConfigGroups/hdfs-NAMENODE-BASE/config?view=full"
    ;;
    *)
      echo "Usage $0 {option}"
      echo "Valid options: default-thresholds, zookeeper, httpfs, mr-client, hdfs-ha, rest-api-examples"
      exit 1
  esac
}

JSON_PATH=/home/training/training_materials/admin/scripts/json
runCMRESTAPI $1
