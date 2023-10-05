DOCKER_NETWORK = fbnet
ENV_FILE = hadoop.env
current_branch := $(shell git rev-parse --abbrev-ref HEAD)

about:
	echo "Current branch is: ${current_branch}. ENV_FILE=${ENV_FILE}. DOCKER_NETWORK=${DOCKER_NETWORK}"

build: about
	docker build -t fcjbispo/fbnet-hadoop-base:$(current_branch) ./base
	docker build -t fcjbispo/fbnet-hadoop-namenode:$(current_branch) ./namenode
	docker build -t fcjbispo/fbnet-hadoop-httpfs:$(current_branch) ./httpfs
	docker build -t fcjbispo/fbnet-hadoop-datanode:$(current_branch) ./datanode
	docker build -t fcjbispo/fbnet-hadoop-resourcemanager:$(current_branch) ./resourcemanager
	docker build -t fcjbispo/fbnet-hadoop-nodemanager:$(current_branch) ./nodemanager
	docker build -t fcjbispo/fbnet-hadoop-historyserver:$(current_branch) ./historyserver
	docker build -t fcjbispo/fbnet-hadoop-wordcount:$(current_branch) ./wordcount

wordcount:
	docker build -t hadoop-wordcount ./submit
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} fcjbispo/fbnet-hadoop-base:$(current_branch) hdfs dfs -mkdir -p /input/
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} fcjbispo/fbnet-hadoop-base:$(current_branch) hdfs dfs -copyFromLocal -f /opt/hadoop-3.2.1/README.txt /input/
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} fcjbispo/fbnet-hadoop-wordcount:$(current_branch)
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} fcjbispo/fbnet-hadoop-base:$(current_branch) hdfs dfs -cat /output/*
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} fcjbispo/fbnet-hadoop-base:$(current_branch) hdfs dfs -rm -r /output
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} fcjbispo/fbnet-hadoop-base:$(current_branch) hdfs dfs -rm -r /input

up:
	docker network create -d bridge fbnet-hadoop
	docker compose -p fbnet-hadoop -f ./docker-compose.yml up --detach

stop:
	docker network create -d bridge fbnet-hadoop
	docker compose -p fbnet-hadoop -f ./docker-compose.yml stop

restart:
	docker network create -d bridge fbnet-hadoop
	docker compose -p fbnet-hadoop -f ./docker-compose.yml restart

down:
	docker compose -p fbnet-hadoop -f ./docker-compose.yml down
	docker network rm fbnet-hadoop