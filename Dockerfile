# syntax=docker/dockerfile:1

FROM openjdk:11-jdk-buster

LABEL version="1.3"

RUN apt-get update && apt-get install -y curl unzip dos2unix && \
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
ENV JVM_OPTS "-Xms2048m -Xmx2048m"
ENV INSTALL_JAR="forge-1.16.5-36.2.20-installer.jar"
ENV SERVER_JAR="forge-1.16.5-36.2.20.jar"
ENV JAVA_JAR=""
ENV MIN_RAM="1024M"
ENV MAX_RAM="4096M"
ENV JAVA_PARAMETERS="-XX:+UseG1GC -Dsun.rmi.dgc.server.gcInterval=2147483646 -XX:+UnlockExperimentalVMOptions -XX:G1NewSizePercent=20 -XX:G1ReservePercent=20 -XX:MaxGCPauseMillis=50 -XX:G1HeapRegionSize=32M -Dfml.readTimeout=180"
	
