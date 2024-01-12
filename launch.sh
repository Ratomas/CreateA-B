#!/bin/bash

set -x

cd /data

if ! [[ "$EULA" = "false" ]] || grep -i true eula.txt; then
	echo "eula=true" > eula.txt
else
	echo "You must accept the EULA by in the container settings."
	exit 9
fi

if ! [[ -f server-1.3.jar ]]; then
	rm -fr config defaultconfigs kubejs mods openloader worldshape forge-1.16.5-*.zip server-*.jar server.properties
	mv /server/* /data/
	
	install_files() {
		java -jar server-1.3.jar --installServer > /dev/null 2>&1
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
if [[ -n "$LEVELTYPE" ]]; then
    sed -i "/level-type\s*=/ c level-type=$LEVELTYPE" server.properties
fi

if [[ -n "$OPS" ]]; then
    echo $OPS | awk -v RS=, '{print}' >> ops.txt
fi

curl -o log4j2_112-116.xml https://launcher.mojang.com/v1/objects/02937d122c86ce73319ef9975b58896fc1b491d1/log4j2_112-116.xml
java $JAVA_FLAGS $JVM_OPTS -XX:MaxPermSize=256M -Dlog4j.configurationFile=log4j2_112-116.xml -jar server-1.3.jar nogui
