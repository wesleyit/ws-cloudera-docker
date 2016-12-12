#!/bin/bash

setMapredHome(){
  echo 
  echo "Setting HADOOP_MAPRED_HOME for YARN."
  echo 
  export HADOOP_MAPRED_HOME=/usr/lib/hadoop-mapreduce
}

installSqoop(){
  echo 
  echo "Installing Sqoop." 
  echo 
  sudo yum install --assumeyes sqoop
}

linkToMySQLDriver(){
  echo 
  echo "Creating a link to the MySQL JDBC driver in the /usr/lib/sqoop/lib directory."
  echo 
  sudo ln -s /usr/share/java/mysql-connector-java.jar /usr/lib/sqoop/lib/
}

importMovieTable(){
  echo 
  echo "Importing the movie table into Hadoop."
  echo 
  sqoop import --connect jdbc:mysql://localhost/movielens --table movie --fields-terminated-by '\t' --username training --password training
}

importMovieratingTable(){
 echo 
 echo "Importing the movierating table into Hadoop."
 echo 
 sqoop import --connect jdbc:mysql://localhost/movielens --table movierating --fields-terminated-by '\t' --username training --password training
}

MYHOST="`hostname`: "
echo 
echo $MYHOST "Running " $0"."
setMapredHome
installSqoop
linkToMySQLDriver
importMovieTable
importMovieratingTable
echo 
echo $MYHOST $0 "done."
