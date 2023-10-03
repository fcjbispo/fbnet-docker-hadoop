FROM fcjbispo/fbnet-hadoop-base:2.0.0-hadoop3.3.6-java8

LABEL AUTHOR="Ivan Ermilov <ivan.s.ermilov@gmail.com>"
LABEL MAINTAINER="Francisco C J Bispo <fcjbispo@franciscobispo.net>"

HEALTHCHECK CMD curl -f http://localhost:8042/ || exit 1

ADD run.sh /run.sh
RUN chmod a+x /run.sh

EXPOSE 8042

CMD ["/run.sh"]
