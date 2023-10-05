#!/bin/bash

namedir=`echo $HDFS_CONF_dfs_httpfs_name_dir | perl -pe 's#file://##'`
if [ ! -d $namedir ]; then
  echo "HttpFS name directory not found: $namedir"
  exit 2
fi

if [ -z "$CLUSTER_NAME" ]; then
  echo "Cluster name not specified"
  exit 2
fi

echo "remove lost+found from $namedir"
rm -r $namedir/lost+found

service ssh restart

echo $HDFS_USER:$HDFS_USER_PASSWD | chpasswd

$HADOOP_HOME/bin/hdfs --config $HADOOP_CONF_DIR httpfs
