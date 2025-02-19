# Ansible & Terraform 자동화 프로젝트

## 개요

이 프로젝트는 Terraform을 사용하여 인프라를 자동으로 구성하고, Ansible을 사용하여 필요한 설정을 자동화하는 환경을 제공합니다. 단순한 명령어 실행만으로 모든 설정이 완료됩니다.

## 설치 및 실행 방법

### 1. 레포지토리 클론

먼저 프로젝트를 클론합니다.

```
https://github.com/joontube/hadoop-hbase-spark-cluster-with-terraform-and-ansible.git
cd hadoop-hbase-spark-cluster-with-terraform-and-ansible
```

### 2. 전체 자동 실행

아래 명령어를 실행하면 Terraform으로 인프라를 생성하고 Ansible로 환경을 설정합니다.

```
./setup_and_run_all.sh
```

### 3. 환경 제거

구성된 인프라와 설정을 제거하려면 다음 명령어를 실행합니다.

```
./destroy_all.sh
```

## 

## 디렉토리 구조

```
hadoop-hbase-spark-cluster-with-terraform-and-ansible/
├── ansible
│   ├── ansible.cfg
│   ├── inventory.ini
│   ├── lib
│   │   ├── hbase-spark-1.1.0-SNAPSHOT.jar
│   │   ├── hbase-spark-protocol-shaded-1.1.0-SNAPSHOT.jar
│   │   └── scala-library-2.12.17.jar
│   ├── run_onlyrun.sh
│   ├── run_playbooks.sh
│   └── yaml_files
│       ├── create_hbase_tables.yml
│       ├── hadoop_common.yml
│       ├── hadoop_master.yml
│       ├── hadoop_workers.yml
│       ├── setup_containers.yml
│       ├── setup_hadoop.yml
│       ├── setup_hbase.yml
│       ├── setup_spark.yml
│       ├── setup_zookeeper.yml
│       ├── start_hadoop.yml
│       ├── start_hbase.yml
│       ├── start_spark.yml
│       ├── start_zookeeper.yml
│       └── test.yml
├── destroy_all.sh
├── scripts
│   └── generate_ssh_key.sh
├── setup_and_run_all.sh
└── terraform
    ├── Dockerfile
    ├── main.tf
    ├── terraform.tfstate
    └── terraform.tfstate.backup
```

## 
