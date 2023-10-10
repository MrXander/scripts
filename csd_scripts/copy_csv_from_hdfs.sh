#!/bin/bash

echo 'FROM:' $1
echo 'TO:' $2

from=$1
to=$2

hdfs_file=$(hdfs dfs -ls $from | grep [p]art | awk '{print $8}')
echo 'HDFS path:' $hdfs_file

name=$(basename $hdfs_file)
echo $name

hdfs dfs -copyToLocal $hdfs_file $to
new_name=$(basename $from)
echo 'NEW NAME:' $new_name
cd $to
mv $name $new_name
ls -ahl $to
echo 'DONE'