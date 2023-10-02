DOCKER_NETWORK = fbnet
ENV_FILE = hadoop.env
current_branch := $(shell git rev-parse --abbrev-ref HEAD)
build:
	docker build -t fcjbispo/fbnet-hadoop-base:$(current_branch) ./base
	docker build -t fcjbispo/fbnet-hadoop-namenode:$(current_branch) ./namenode
	docker build -t fcjbispo/fbnet-hadoop-datanode:$(current_branch) ./datanode
	docker build -t fcjbispo/fbnet-hadoop-resourcemanager:$(current_branch) ./resourcemanager
	docker build -t fcjbispo/fbnet-hadoop-nodemanager:$(current_branch) ./nodemanager
	docker build -t fcjbispo/fbnet-hadoop-historyserver:$(current_branch) ./historyserver
	docker build -t fcjbispo/fbnet-hadoop-submit:$(current_branch) ./submit

wordcount:
	docker build -t hadoop-wordcount ./submit
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} fcjbispo/fbnet-hadoop-base:$(current_branch) hdfs dfs -mkdir -p /input/
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} fcjbispo/fbnet-hadoop-base:$(current_branch) hdfs dfs -copyFromLocal -f /opt/hadoop-3.2.1/README.txt /input/
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} hadoop-wordcount
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} fcjbispo/fbnet-hadoop-base:$(current_branch) hdfs dfs -cat /output/*
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} fcjbispo/fbnet-hadoop-base:$(current_branch) hdfs dfs -rm -r /output
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} fcjbispo/fbnet-hadoop-base:$(current_branch) hdfs dfs -rm -r /input
