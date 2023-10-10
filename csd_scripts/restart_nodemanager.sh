#!/bin/bash

sudo su -
echo "STOPPING NODEMANAGER"
#/etc/init.d/hadoop-yarn-nodemanager stop
echo "NODEMANAGER STOPPED"
echo "CLEANING /var/log/hadoop-yarn/userlogs"
cd /var/log/hadoop-yarn/userlogs
echo "CURRENT DIR"
echo pwd