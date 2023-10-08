FROM fcjbispo/fbnet-hadoop-base:2.0.0-hadoop3.3.6-java8

LABEL AUTHOR="Francisco C J Bispo <fcjbispo@franciscobispo.net>"

# HEALTHCHECK CMD curl -f http://localhost:14000/ || exit 

ARG X_HDFS_USER=fbnet
ARG X_HDFS_GROUP=supergroup

ENV HDFS_USER=$X_HDFS_USER
ENV HDFS_USER_PASSWORD=_Admin123

RUN useradd -m -s /usr/bin/bash $HDFS_USER \
  && echo "$HDFS_USER:$HDFS_USER_PASSWORD" | chpasswd \
  && adduser $HDFS_USER sudo

RUN cat /home/$HDFS_USER/.bashrc > /tmp/bashrc.tmp \
  && echo "export HADOOP_HOME=/opt/hadoop-3.3.6" > /home/$HDFS_USER/.bashrc \
  && echo "export PATH=$HADOOP_HOME/bin:$PATH" >> /home/$HDFS_USER/.bashrc \
  && echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> /home/$HDFS_USER/.bashrc \
  && cat /tmp/bashrc.tmp >> /home/$HDFS_USER/.bashrc

RUN mkdir -p /var/httpfs
RUN chown -R $HDFS_USER:$HDFS_USER /var/httpfs

VOLUME /var/httpfs

ADD run.sh /run.sh
RUN chmod a+x /run.sh

EXPOSE 22 14000

RUN echo "export CLASSPATH=`$HADOOP_HOME/bin/hdfs classpath --glob`" >> /home/$HDFS_USER/.bashrc

RUN chown -R $HDFS_USER:$HDFS_USER /home/$X_HDFS_USER

CMD ["/run.sh"]
