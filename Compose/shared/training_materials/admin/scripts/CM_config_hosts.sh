#!/bin/bash

removeCruft() {
  if [ -f /home/training/.ssh/known_hosts ]; then
    rm /home/training/.ssh/known_hosts
  fi
  sudo sed -i '/elephant/d' /etc/hosts
  sudo sed -i '/tiger/d' /etc/hosts
  sudo sed -i '/horse/d' /etc/hosts
  sudo sed -i '/monkey/d' /etc/hosts
  sudo sed -i '/lion/d' /etc/hosts
}

determineEnvironment(){
  if grep -q "K=vmware" /etc/vmbuild.info
  then 
    classenv=vmware
  else
    classenv=ec2
  fi
}

updateHostsFile() {
  if [ $classenv == "vmware" ]; then
    sudo sh -c "echo 192.168.123.1 elephant >> /etc/hosts"
    sudo sh -c "echo 192.168.123.2 tiger >> /etc/hosts"
    sudo sh -c "echo 192.168.123.3 horse >> /etc/hosts"
    sudo sh -c "echo 192.168.123.4 monkey >> /etc/hosts"
    sudo sh -c "echo 192.168.123.5 lion >> /etc/hosts"
  else
    echo ""
    echo "Please supply the EC2 private IP addresses of your four EC2 instances."
    echo "These are the IP addresses that usually start with 10, 172, and 192.168."
    echo ""
    invalidIP=0
    echo "What is the EC2 private IP address of your first machine (elephant)?"
    read ip1
    if [[ $ip1 != 10.* && $ip1 != 172.* && $ip1 != 192.168.* ]]; then
      invalidIP=1
    fi
    echo "What is the EC2 private IP address of your second machine (tiger)?"
    read ip2
    if [[ $ip2 != 10.* && $ip2 != 172.* && $ip2 != 192.168.* ]]; then
      invalidIP=1
    fi
    echo "What is the EC2 private IP address of your third machine (horse)?"
    read ip3
    if [[ $ip3 != 10.* && $ip3 != 172.* && $ip3 != 192.168.* ]]; then
      invalidIP=1
    fi
    echo "What is the EC2 private IP address of your fourth machine (monkey)?"
    read ip4
    if [[ $ip4 != 10.* && $ip4 != 172.* && $ip4 != 192.168.* ]]; then
      invalidIP=1
    fi
    echo "What is the EC2 private IP address of your fifth machine (lion)?"
    read ip5
    if [[ $ip5 != 10.* && $ip5 != 172.* && $ip5 != 192.168.* ]]; then
    invalidIP=1
    fi

    echo
    echo "Please verify that these are the correct IP addresses:"
    echo "elephant:" $ip1 
    echo "tiger:" $ip2
    echo "horse:" $ip3
    echo "monkey:" $ip4
    echo "lion:" $ip5

    echo
    echo "Type Y if these are the correct IP addresses, N if not."
    read answer 
    if [[ $answer != "Y" && $answer != "y" ]]; then
      echo 
      echo "Please restart this command and provide correct IP addresses."
      echo 
      exit
    fi

    if [[ $invalidIP == "1" ]] ; then
      echo 
      echo "You have entered one or more private IP addresses"
      echo "that do not start with 10, 172, or 192.168."
      echo "OK to Continue? Type Y if you are sure want to proceed."
      read validation
      if [[ $validation != "Y" && $validation != "y" ]]; then
        echo 
        echo "Please restart this command and provide correct IP addresses."
        echo
        exit
      fi
    fi 

    sudo sh -c "echo $ip1 elephant >> /etc/hosts"
    sudo sh -c "echo $ip2 tiger >> /etc/hosts"
    sudo sh -c "echo $ip3 horse >> /etc/hosts"
    sudo sh -c "echo $ip4 monkey >> /etc/hosts"
    sudo sh -c "echo $ip5 lion >> /etc/hosts"
    return 0
  fi
}

copyHostsFile() {
  echo $MYHOST "Copying the /etc/hosts files to the other four hosts in the cluster."
  scp /etc/hosts root@tiger:/etc/hosts
  scp /etc/hosts root@horse:/etc/hosts
  scp /etc/hosts root@monkey:/etc/hosts
  scp /etc/hosts root@lion:/etc/hosts
}

renameHosts() {
  echo 
  echo "Changing the /etc/sysconfig/network files on all the hosts in the cluster." 
  echo 
  sudo sed -i s/localhost.localdomain/elephant/ /etc/sysconfig/network
  ssh training@tiger 'sudo sed -i s/localhost.localdomain/tiger/ /etc/sysconfig/network'
  ssh training@horse 'sudo sed -i s/localhost.localdomain/horse/ /etc/sysconfig/network'
  ssh training@monkey 'sudo sed -i s/localhost.localdomain/monkey/ /etc/sysconfig/network'
  ssh training@lion 'sudo sed -i s/localhost.localdomain/lion/ /etc/sysconfig/network'

  echo 
  echo "Resetting the host names for the current sessions on all hosts in the cluster."
  echo 
  sudo hostname elephant
  ssh training@tiger 'sudo hostname tiger'
  ssh training@horse 'sudo hostname horse'
  ssh training@monkey 'sudo hostname monkey'
  ssh training@lion 'sudo hostname lion'
}

MYHOST="`hostname`: "
# Avoid "sudo: cannot get working directory" errors by
# changing to a directory owned by the training user
cd ~
echo 
echo $MYHOST "Running " $0"."
removeCruft
determineEnvironment
updateHostsFile
copyHostsFile
renameHosts
echo 
echo $MYHOST $0 "done."
