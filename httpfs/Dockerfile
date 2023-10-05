FROM fcjbispo/fbnet-hadoop-base:2.0.0-hadoop3.3.6-java8

LABEL AUTHOR="Francisco C J Bispo <fcjbispo@franciscobispo.net>"

HEALTHCHECK CMD curl -f http://localhost:14000/ || exit 

ARG X_HDFS_USER=fbnet
ARG X_HDFS_GROUP=supergroup

RUN useradd -m -s /usr/bin/bash $X_HDFS_USER \
  && echo "$X_HDFS_USER:$X_HDFS_GROUP" | chpasswd \
  && adduser $X_HDFS_USER sudo

ENV HDFS_CONF_dfs_httpfs_name_dir=file:///var/httpfs
RUN mkdir -p /var/httpfs
RUN chown -R $X_HDFS_USER:$X_HDFS_USER /var/httpfs
VOLUME /var/httpfs

ENV HDFS_USER=$X_HDFS_USER

ADD run.sh /run.sh
RUN chmod a+x /run.sh

EXPOSE 22 14000

CMD ["/run.sh"]
