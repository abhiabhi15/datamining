#!/usr/bin/env bash

cd $HADOOP_PREFIX

bin/stop-all.sh
rm -rf log/*
rm -rf /opt/hadoop/tmp/*

hadoop namenode -format

cd $HADOOP_PREFIX

bin/start-all.sh
bin/hadoop dfs -copyFromLocal /opt/stanford /stanford
bin/hadoop dfs -ls /stanford

myjar=$1
bin/hadoop jar $myjar main.java.Executor /stanford /temp /output 
bin/hadoop dfs -getmerge /output ~/output.txt

