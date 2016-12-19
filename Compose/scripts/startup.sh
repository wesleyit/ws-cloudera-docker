#!/bin/bash -m

## Change to the dir where the script is located and
# get the full name into a variable
cd /scripts
cat <<EOF
=================================================
+ Date: $(date)
+ Folder: $WORK_DIR
+ Running at $(hostname)"
=================================================
EOF

## Copy the config files to the hadoop dir
function create_config() {
	\cp -f core-site.xml hdfs-site.xml \
					yarn-site.xml mapred-site.xml \
					hadoop-env.sh /etc/hadoop/conf/
	source /etc/hadoop/conf/hadoop-env.sh
}

## Create the directories
function create_dirs() {
	mkdir -p /disk{1,2}/dfs/{nn,dn}
	mkdir -p /disk{1,2}/nodemgr/local
}

## Fix permissions
function set_permissions() {
	chown -R hdfs:hadoop /disk{1,2}/dfs/{nn,dn}
	chown -R yarn:yarn /disk{1,2}/nodemgr/local
}

## Format the namenode if this is the right server and start
function format_namenode() {
cat << EOF | sudo -Es -u hdfs
	hdfs namenode -format 
	sleep 5
EOF
}

## Basic tasks to setup directories
create_config
create_dirs
set_permissions

## Namenode Startup
if [ "$IS_NAMENODE" == "yes" -o "$1" == "format" ]
then
	format_namenode
	service hadoop-hdfs-namenode start
fi

## SecNamenode Startup
if [ "$IS_SECNAMENODE" == "yes" ]
then
	service hadoop-hdfs-secondarynamenode start
fi

## Yarn Startup
if [ "$IS_YARNNODE" == "yes" ]
then
	service hadoop-yarn-resourcemanager start
fi

## JobHistory Startup
if [ "$IS_HISTORYNODE" == "yes" ]
then
	sudo -u hdfs hadoop fs -mkdir /tmp
	sudo -u hdfs hadoop fs -chmod -R 1777 /tmp
	sudo -u hdfs hadoop fs -mkdir -p /var/log/hadoop-yarn
	sudo -u hdfs hadoop fs -chown yarn:mapred /var/log/hadoop-yarn
	sudo -u hdfs hadoop fs -mkdir /user
	sudo -u hdfs hadoop fs -mkdir /user/training
	sudo -u hdfs hadoop fs -chown training /user/training
	sudo -u hdfs hadoop fs -mkdir /user/history
	sudo -u hdfs hadoop fs -chmod 1777 /user/history
	sudo -u hdfs hadoop fs -chown mapred:hadoop /user/history
	sleep 5
	service hadoop-mapreduce-historyserver start
fi

## Run the Datanode and Node Manager
service hadoop-hdfs-datanode start
service hadoop-yarn-nodemanager start

## Improve the usability
cat > /var/lib/hadoop-hdfs/.bashrc << EOF
#!/bin/bash
export PS1='[\u@\h: \w]\$ '
EOF
chown hdfs:hadoop /var/lib/hadoop-hdfs/.bashrc
chmod 755 /var/lib/hadoop-hdfs/.bashrc
echo 'hdfs ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/hdfs

## Keep running
tail -f /var/log/hadoop-*/*

