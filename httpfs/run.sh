#!/bin/bash

if [ -z "$CLUSTER_NAME" ]; then
  echo "Cluster name not specified"
  exit 2
fi

echo "remove lost+found from $namedir"
rm -r $namedir/lost+found

service ssh restart

echo $HDFS_USER:$HDFS_USER_PASSWORD | chpasswd

$HADOOP_HOME/bin/hdfs --config $HADOOP_CONF_DIR httpfs
