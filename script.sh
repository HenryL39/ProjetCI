VERSION=$1
SNAPSHOT="SNAPSHOT"
echo $VERSION
if [[ "$VERSION" == *"SNAPSHOT" ]]
then
	echo "version snapshot detectée"
	LINK=http://192.168.100.79:8081/repository/maven-snapshots/com/lesformateurs/maven-project/server
	wget -O inside_metadata.xml $LINK/$VERSION/maven-metadata.xml
	if [ $? -ne 0 ]
	then
		echo "numéro de version n'existe pas sur le serveur"
		exit 1
	fi
	echo $VERSION
	NBVERSION=$(cat inside_metadata.xml | grep "<value>" | tail -1 | tr -d "<value> " | tr -d "/")
	echo $NBVERSION
	JAR=$(echo $LINK/$VERSION/server-$NBVERSION.jar)
	wget -O server.jar $JAR
	scp -r -p ./server.jar user01@192.168.100.89:/data/projet/
else
	echo "version release detectée"
	LINK=http://192.168.100.79:8081/repository/maven-releases/com/lesformateurs/maven-project/server
        echo $VERSION
        JAR=$(echo $LINK/$VERSION/server-$VERSION.jar)
	wget -O server.jar $JAR
	if [ $? -ne 0 ]
	then
		echo "le numéro de version n'existe pas sur le serveur"
		exit 2
	fi
        scp -r -p ./server.jar user01@192.168.100.89:/data/projet/
fi
