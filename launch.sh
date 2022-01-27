#!/bin/bash

set -x

cd /data

if ! [[ "$EULA" = "false" ]] || grep -i true eula.txt; then
	echo "eula=true" > eula.txt
else
	echo "You must accept the EULA by in the container settings."
	exit 9
fi

if ! [[ -f Above+and+Beyond-1.3-Server.zip ]]; then
	rm -fr config defaultconfigs global_data_packs global_resource_packs mods packmenu Above+and+Beyond-*-Server.zip
	curl -L -o Above+and+Beyond-1.3-Server.zip https://www.curseforge.com/minecraft/modpacks/create-above-and-beyond/download/3567576 && unzip -u -o Above+and+Beyond-1.3-Server.zip -d /data
	
	install_files() {
		java -jar ${INSTALL_JAR} --installServer > /dev/null 2>&1
	}
	
	echo "Installing Forge and required jars."
	install_files
	echo "Done!"
fi

if [[ -n "$MOTD" ]]; then
    sed -i "/motd\s*=/ c motd=$MOTD" /data/server.properties
fi
if [[ -n "$LEVEL" ]]; then
    sed -i "/level-name\s*=/ c level-name=$LEVEL" /data/server.properties
fi

if [[ -n "$OPS" ]]; then
    echo $OPS | awk -v RS=, '{print}' >> ops.txt
fi

curl -o log4j2_112-116.xml https://launcher.mojang.com/v1/objects/02937d122c86ce73319ef9975b58896fc1b491d1/log4j2_112-116.xml
java $JVM_OPTS -XX:MaxPermSize=256M -Dlog4j.configurationFile=log4j2_112-116.xml -jar $SERVER_JAR nogui
