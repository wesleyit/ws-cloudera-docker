#!/bin/bash

copyAgentConfig() {
  echo 
  echo Copying the agent configuration to tiger, horse, monkey, and lion.
  echo
  scp /etc/cloudera-scm-agent/config.ini root@tiger:/etc/cloudera-scm-agent/
  scp /etc/cloudera-scm-agent/config.ini root@horse:/etc/cloudera-scm-agent/
  scp /etc/cloudera-scm-agent/config.ini root@monkey:/etc/cloudera-scm-agent/
  scp /etc/cloudera-scm-agent/config.ini root@lion:/etc/cloudera-scm-agent/
}

MYHOST="`hostname`: "
echo 
echo $MYHOST "Running " $0"."
copyAgentConfig
echo 
echo $MYHOST $0 "done."
