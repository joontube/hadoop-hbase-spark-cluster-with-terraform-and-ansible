i#!/bin/bash

# Ansible Playbooks 실행 스크립트

echo "Starting Ansible Playbooks Execution..."

# 1. 컨테이너 설정
echo "Running setup_container.yml..."
ansible-playbook ./yaml_files/setup_containers.yml

# 2. Hadoop 공통 설정
echo "Running setup_hadoop.yml..."
ansible-playbook ./yaml_files/setup_hadoop.yml

# 5. ZooKeeper 설정
echo "Running setup_zookeeper.yml..."
ansible-playbook ./yaml_files/setup_zookeeper.yml

# 6. HBase 설정
echo "Running setup_hbase.yml..."
ansible-playbook ./yaml_files/setup_hbase.yml

# 7. Spark 설정
echo "Running setup_spark.yml..."
ansible-playbook ./yaml_files/setup_spark.yml

# 8. Hadoop 시작
echo "Running start_hadoop.yml"
ansible-playbook ./yaml_files/start_hadoop.yml

# 9. Zookeeper 시작
echo "Running start_zookeeper.yml"
ansible-playbook ./yaml_files/start_zookeeper.yml

# 10. Hbase 시작하고 테이블 생성
echo "Running start_hbase.yml"
#ansible-playbook ./yaml_files/start_hbase.yml
docker exec -it master1 sudo /usr/local/hbase/bin/start-hbase.sh
docker exec -it master1 sudo /usr/local/hbase/bin/hbase-daemon.sh start rest
ansible-playbook ./yaml_files/create_hbase_tables.yml

# 11. Spark Connect 시작
echo "Running start_spark.yml"
#ansible-playbook ./yaml_files/start_spark.yml
docker exec -it /usr/local/spark/sbin/start-connect-server.sh   --conf spark.connect.grpc.binding.port=33465 --packages org.apache.spark:spark-connect_2.12:3.4.4

echo "All Playbooks Executed Successfully!"

