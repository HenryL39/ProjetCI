#Prend le nom de la version demandée en paramètre de la commande
VERSION=$1
#Vérifie si la version est une snapshot ou une release par une comparaison de chaîne de caractères
if [[ "$VERSION" == *"SNAPSHOT" ]]
then
	echo "version snapshot detectée"
	#Declaration du lien vers lequel le jar doit être récupéré
	LINK=http://192.168.100.79:8081/repository/maven-snapshots/com/lesformateurs/maven-project/server
	#Prend le fichier maven-metadata.xml pour récuperer dedans la version exacte
	wget -O inside_metadata.xml $LINK/$VERSION/maven-metadata.xml
	#Vérification de l'existence de la version
	if [ $? -ne 0 ]
	then
		echo "numéro de version n'existe pas sur le serveur"
		exit 1
	fi
	#Parse du fichier XML pour récupérer le numéro de version formaté
	NBVERSION=$(cat inside_metadata.xml | grep "<value>" | tail -1 | tr -d "<value> " | tr -d "/")
	echo $NBVERSION
	#Déclaration du lien exact vers le fichier jar
	JAR=$(echo $LINK/$VERSION/server-$NBVERSION.jar)
	#Récupération du fichier jar sur Nexus
	wget -O server"$VERSION".jar $JAR
	#Copie du fichier jar vers la machine distante via SCP
	scp -r -p ./server"$VERSION".jar user01@192.168.100.89:/data/projet/
else
	echo "version release detectée"
	#Declaration du lien vers lequel le jar doit être récupéré
	LINK=http://192.168.100.79:8081/repository/maven-releases/com/lesformateurs/maven-project/server
        echo $VERSION
	#Déclaration du lien exact vers le fichier jar
        JAR=$(echo $LINK/$VERSION/server-$VERSION.jar)
	#Récupération du fichier jar sur Nexus
	wget -O server"$VERSION".jar $JAR
	#Vérification de l'existence de la version
	if [ $? -ne 0 ]
	then
		echo "le numéro de version n'existe pas sur le serveur"
		exit 2
	fi
	#Copie du fichier jar vers la machine distante via SCP
        scp -r -p ./server"$VERSION".jar user01@192.168.100.89:/data/projet/
fi
