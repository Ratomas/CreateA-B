# syntax=docker/dockerfile:1

FROM openjdk:11-jdk-buster

LABEL version="1.3"

RUN apt-get update && apt-get install -y curl dos2unix && \
 addgroup minecraft && \
 adduser --home /data --ingroup minecraft --disabled-password minecraft

COPY launch.sh /launch.sh
RUN dos2unix /launch.sh
RUN chmod +x /launch.sh

USER minecraft

VOLUME /data
WORKDIR /data

EXPOSE 25565/tcp

CMD ["/launch.sh"]

ENV MOTD "Create Above & Beyond v1.3 Server Powered by Docker"
ENV LEVEL world
ENV LEVELTYPE ""
ENV JVM_OPTS "-Xms2048m -Xmx6144m"
ENV SERVER_JAR="forge-1.16.5-36.2.20.jar"
	
