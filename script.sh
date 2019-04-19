#LINK=http://192.168.100.79:8081/repository/maven-snapshots/com/lesformateurs/maven-project/server
#wget $LINK/maven-metadata.xml
#VERSION=$(cat maven-metadata.xml | grep "<version>" | tail -1 | tr -d '<version> ' | tr -d '/')
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
	#LATEST=$(cat maven-metadata.xml | grep "<lastUpdated>" | tr -d '<lastUpdated> ' | tr -d '/')
	echo $VERSION
	NBVERSION=$(cat inside_metadata.xml | grep "<value>" | tail -1 | tr -d "<value> " | tr -d "/")
	echo $NBVERSION
	#echo $LATEST
	JAR=$(echo $LINK/$VERSION/server-$NBVERSION.jar)
	wget $JAR
else
#then
	echo "version release detectée"
	LINK=http://192.168.100.79:8081/repository/maven-releases/com/lesformateurs/maven-project/server
        #LATEST=$(cat maven-metadata.xml | grep "<lastUpdated>" | tr -d '<lastUpdated> ' | tr -d '/')
        echo $VERSION
        #NBVERSION=$(cat inside_metadata.xml | grep "<value>" | tail -1 | tr -d "<value> " | tr -d "/")
        #echo $NBVERSION
        #echo $LATEST
        JAR=$(echo $LINK/$VERSION/server-$VERSION.jar)
	wget $JAR
	if [ $? -ne 0 ]
	then
		echo "le numéro de version n'existe pas sur le serveur"
		exit 2
	fi
#else
#	echo "veuillez rentrer un numéro de version ou de snapshot valide"
#	exit 3
fi
