#!/bin/bash
MYHOST="`hostname`: "
echo 
echo $MYHOST "Running " $0"."
echo 
echo $MYHOST "Running the WordCount program." 
echo 
hadoop jar /usr/lib/hadoop-mapreduce/hadoop-mapreduce-examples.jar wordcount input counts
echo 
echo $MYHOST "Deleting the output and running the WordCount program again." 
echo 
hadoop fs -rm -r counts
hadoop jar /usr/lib/hadoop-mapreduce/hadoop-mapreduce-examples.jar wordcount -D mapred.reduce.child.log.level=DEBUG input counts 
echo 
echo $MYHOST $0 "done."
