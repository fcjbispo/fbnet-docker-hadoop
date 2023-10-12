DOCKER_NETWORK = fbnet-hadoop
DOCKER_PROJECT = fbnet-hadoop
ENV_FILE = hadoop.env
current_branch := $(shell git rev-parse --abbrev-ref HEAD)

base: base/Dockerfile
	docker build -t fcjbispo/fbnet-hadoop-base:$(current_branch) ./base

namenode: namenode/Dockerfile
	docker build -t fcjbispo/fbnet-hadoop-namenode:$(current_branch) ./namenode

httpfs: httpfs/Dockerfile
	docker build -t fcjbispo/fbnet-hadoop-httpfs:$(current_branch) ./httpfs

datanode: datanode/Dockerfile
	docker build -t fcjbispo/fbnet-hadoop-datanode:$(current_branch) ./datanode

resourcemanager: resourcemanager/Dockerfile
	docker build -t fcjbispo/fbnet-hadoop-resourcemanager:$(current_branch) ./resourcemanager

nodemanager: nodemanager/Dockerfile
	docker build -t fcjbispo/fbnet-hadoop-nodemanager:$(current_branch) ./nodemanager

historyserver: historyserver/Dockerfile
	docker build -t fcjbispo/fbnet-hadoop-historyserver:$(current_branch) ./historyserver

wordcount: wordcount/Dockerfile
	docker build -t fcjbispo/fbnet-hadoop-wordcount:$(current_branch) ./wordcount

all: base namenode httpfs datanode resourcemanager nodemanager historyserver wordcount
	echo "Current branch is: ${current_branch}. ENV_FILE=${ENV_FILE}. DOCKER_NETWORK=${DOCKER_NETWORK}"

run-wordcount:
	docker build -t hadoop-wordcount ./submit
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} fcjbispo/fbnet-hadoop-base:$(current_branch) hdfs dfs -mkdir -p /input/
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} fcjbispo/fbnet-hadoop-base:$(current_branch) hdfs dfs -copyFromLocal -f /opt/hadoop-3.2.1/README.txt /input/
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} fcjbispo/fbnet-hadoop-wordcount:$(current_branch)
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} fcjbispo/fbnet-hadoop-base:$(current_branch) hdfs dfs -cat /output/*
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} fcjbispo/fbnet-hadoop-base:$(current_branch) hdfs dfs -rm -r /output
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} fcjbispo/fbnet-hadoop-base:$(current_branch) hdfs dfs -rm -r /input

up:
	if [ -n $(docker network ls | grep ${DOCKER_NETWORK}) ]; then docker network create -d bridge ${DOCKER_NETWORK}; fi
	docker compose -p ${DOCKER_PROJECT} -f ./docker-compose.yml up --detach

stop:
	docker compose -p ${DOCKER_PROJECT} -f ./docker-compose.yml stop

restart:
	docker compose -p ${DOCKER_PROJECT} -f ./docker-compose.yml restart

down:
	docker compose -p ${DOCKER_PROJECT} -f ./docker-compose.yml down
	docker network rm --force ${DOCKER_NETWORK}
	for v in vol-hadoop_datanode1 vol-hadoop_datanode2 vol-hadoop_datanode3 vol-hadoop_historyserver vol-hadoop_httpfs vol-hadoop_namenode; do docker volume rm --force $${v}; done;
