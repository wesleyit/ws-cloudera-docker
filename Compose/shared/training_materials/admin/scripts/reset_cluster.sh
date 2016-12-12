#!/bin/bash

getStartState() {
  validResponse=0
  while [ $validResponse -eq 0 ] 
  do 
    echo ""
    echo "Please enter the number of the exercise that you want to do."
    echo "This script will reset your cluster to the start state for that exercise."
    echo ""
    echo " 1 Installing Hadoop"
    echo " 2 Working With HDFS"
    echo " 3 Using Flume to Put Data into HDFS"
    echo " 4 Importing Data With Sqoop"
    echo " 5 Running a MapReduce Job"
    echo " 6 Creating A Hadoop Cluster"
    echo " 7 Querying HDFS With Hive and Cloudera Impala"
    echo " 8 Using Hue to Control Hadoop User Access"
    echo " 9 Configuring HDFS High Availability"
    echo "10 Managing Jobs"
    echo "11 Using the Fair Scheduler"
    echo "12 Breaking The Cluster"
    echo "13 Verifying The Cluster’s Self-Healing Features"
    echo "14 The Troubleshooting Challenges"
    echo ""
    read exercise
    if [[ $exercise -ge 1 && $exercise -le 14 ]]; then
      validResponse=1
    else 
      echo ""
      echo "Invalid response. Please re-enter a valid exercise number." 
      echo ""
    fi
  done  
} 

getConfirmation(){
  validResponse=0
  while [ $validResponse -eq 0 ] 
  do 
    echo ""
    echo "You are about to reset your cluster so that you can perform Exercise "$exercise"."
    echo ""
    echo "This script will destroy everything you have done on your cluster up until now. OK to proceed? (y/n)"
    echo ""
    read answer
    if [[ $answer == "Y" || $answer == "y" ]]; then
      validResponse=1
    elif [[ $answer == "N" || $answer == "n" ]]; then
      exit
    else 
      echo ""
      echo "Invalid response." 
      echo ""
    fi
  done  
}

cleanup(){
    echo ""
    echo "Stopping all Hadoop processes, removing Hadoop software, removing files, and resetting other changes to your system."
    echo ""
    $CATCHUP_DIR"00Cleanup.sh"
}

doExercise1(){
  if [[ $exercise -gt 1 ]]; then
    echo ""
    echo "Simulating Exercise 1."
    echo ""
    $CATCHUP_DIR"01Install.sh"
  fi
}

doExercise2(){
  if [[ $exercise -gt 2 ]]; then
    echo ""
    echo "Simulating Exercise 2."
    echo ""
    $CATCHUP_DIR"02HDFS.sh"
  fi
}

doExercise3(){
  if [[ $exercise -gt 3 ]]; then
    echo ""
    echo "Simulating Exercise 3."
    echo ""
    $CATCHUP_DIR"03Flume.sh"
  fi
}

doExercise4(){
  if [[ $exercise -eq 5 ]]; then
    echo ""
    echo "Simulating Exercise 4."
    echo ""
    $CATCHUP_DIR"04Sqoop.sh"
  elif [[ $exercise -gt 5 ]]; then
    echo ""
    echo "Simulating Exercise 4 (abbreviated version) to save some time."
    echo "HDFS changes made in Exercise 4 are not needed for Exercise 6 and beyond."
    echo ""
    $CATCHUP_DIR"04SqoopAbbreviated.sh"
  fi
}

doExercise5(){
  if [[ $exercise -gt 5 ]]; then
    echo ""
    echo "Skipping Exercise 5 to save some time."
    echo "HDFS changes made in Exercise 5 are not needed for Exercise 6 and beyond."
    echo ""
  fi
}

doExercise6(){
  if [[ $exercise -gt 6 ]]; then
    echo ""
    echo "Simulating Exercise 6."
    echo ""
    $CATCHUP_DIR"06Cluster.sh"
  fi
}

doExercise7(){
  if [[ $exercise -gt 7 ]]; then
    echo ""
    echo "Simulating Exercise 7."
    echo ""
    $CATCHUP_DIR"07HiveImpala.sh"
  fi
}

doExercise8(){
  if [[ $exercise -gt 8 ]]; then
    echo ""
    echo "Simulating Exercise 8."
    echo ""
    $CATCHUP_DIR"08Hue.sh"
  fi
}

doExercise9(){
  if [[ $exercise -gt 9 ]]; then
    echo ""
    echo "Simulating Exercise 9."
    echo ""
    $CATCHUP_DIR"09NameNodeHA.sh"
  fi
}

doExercise10(){
  if [[ $exercise -gt 10 ]]; then
    echo ""
    echo "Simulating Exercise 10."
    echo ""
    $CATCHUP_DIR"10ManagingJobs.sh"
  fi
}

doExercise11(){
  if [[ $exercise -gt 11 ]]; then
    echo ""
    echo "Simulating Exercise 11."
    echo ""
    $CATCHUP_DIR"11Scheduler.sh"
  fi
}

doExercise12(){
  if [[ $exercise -gt 12 ]]; then
    echo ""
    echo "Simulating Exercise 12."
    echo ""
    $CATCHUP_DIR"12BreakCluster.sh"
  fi
}

MYHOST="`hostname`: "
CATCHUP_DIR="/home/training/training_materials/admin/scripts/catchup/"
# Avoid "sudo: cannot get working directory" errors by
# changing to a directory owned by the training user
cd ~
echo
echo $MYHOST "Running " $0"."
getStartState
getConfirmation
cleanup
doExercise1
doExercise2
doExercise3
doExercise4
doExercise5
doExercise6
doExercise7
doExercise8
doExercise9
doExercise10
doExercise11
doExercise12
echo 
echo $MYHOST $0 "done."
