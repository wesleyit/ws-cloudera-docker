#!/bin/bash
#
# 2012-10-07 Ian Wrigley (originally clouderanetworking script)
# 2013-10-07 David Goldsmith - updated for Admin 201306
#
# Sets a static IP address

determineEnvironment(){
  if !(grep -q "K=vmware" /etc/vmbuild.info)
  then 
    echo "You should not run this script unless you are running on vmware."
    exit
  fi
}

intro(){
  clear
  echo "In this class, you use four hosts: elephant, tiger, horse, and monkey."
  echo "All four hosts initially have the same IP address."
  echo "Run this script on three of the hosts so that the four hosts have unique IP addresses."
}

verifyifcfgFile() {
  if !(diff /etc/sysconfig/network-scripts/ifcfg-eth0 /home/training/config/ifcfg-eth0.original > /dev/null)
  then
    echo 
    echo "The original contents in the /etc/sysconfig/network-scripts/ifcfg-eth0 file have been changed."
    echo 
    echo "OK to proceed? [Y/N]"
    read OKtoProceed
    if [[ $OKtoProceed == "Y" || $OKtoProceed == "y" ]]; then
      echo 
      echo "Restoring the original contents to the /etc/sysconfig/network-scripts/ifcfg-eth0 file."
      echo 
      sudo cp /home/training/config/ifcfg-eth0.original /etc/sysconfig/network-scripts/ifcfg-eth0
    else 
      exit
    fi
  fi
}

acceptInput() {
  echo 
  echo "Enter a host name - either tiger, horse, or monkey."
  echo 
  read thishost

  if [[ $thishost != "tiger" && $thishost != "horse" && $thishost != "monkey" ]]; then
    echo 
    echo "The host name must be tiger, horse, or monkey."
    echo 
    acceptInput
  else 
    echo "You entered the host name as $thishost."
    echo 
    echo "Is that correct? [Y/N]"
    read correct
    if [[ $correct != "Y" && $correct != "y" ]]; then
      acceptInput
    fi
  fi
}

setIPAddress(){
  if [ $thishost == "tiger" ]; then
    ip="192.168.123.2"
  elif [ $thishost == "horse" ]; then
    ip="192.168.123.3"
  else ip="192.168.123.4"
  fi

  # Set IP address in ifcfg-eth0
  sudo sed -i "s/192.168.123.1/$ip/" /etc/sysconfig/network-scripts/ifcfg-eth0
}

restartNetwork(){
  sudo service network restart
  echo 
  echo "Network restarted; your new IP address appears under eth0 below."
  ip addr
}

# Avoid "sudo: cannot get working directory" errors by
# changing to a directory owned by the training user
cd ~
intro
verifyifcfgFile
acceptInput
setIPAddress
restartNetwork
