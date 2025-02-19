i#!/bin/bash


echo "Running start_hadoop.yml"
ansible-playbook ./yaml_files/start_hadoop.yml

echo "Running start_zookeeper.yml"
ansible-playbook ./yaml_files/start_zookeeper.yml

echo "Running start_hbase.yml"
ansible-playbook ./yaml_files/start_hbase.yml

echo "Running start_spark.yml"
ansible-playbook ./yaml_files/start_spark.yml

echo "All Playbooks Executed Successfully!"
