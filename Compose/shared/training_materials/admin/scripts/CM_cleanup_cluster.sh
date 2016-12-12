#!/bin/bash

getConfirmation(){
  validResponse=0
  while [ $validResponse -eq 0 ] 
  do 
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
    $CATCHUP_DIR"00Cleanup.sh" CM
}

MYHOST="`hostname`: "
CATCHUP_DIR="/home/training/training_materials/admin/scripts/catchup/"
# Avoid "sudo: cannot get working directory" errors by
# changing to a directory owned by the training user
cd ~
echo
echo $MYHOST "Running " $0"."
getConfirmation
cleanup
echo 
echo $MYHOST $0 "done."
