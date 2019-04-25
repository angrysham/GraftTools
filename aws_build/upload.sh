#!/bin/bash

source /home/ubuntu/.bash_env

if [ -z "$UPLOAD_USER" ]; then
        echo -e "Envoronment UPLOAD_USER hasn't been defined. Please export it to continue..."
        exit 1
fi

if [ -z "$UPLOAD_PASSWORD" ]; then
        echo -e "Envoronment UPLOAD_PASSWORD hasn't been defined. Please export it to continue..."
        exit 1
fi


if [ -z "$UPLOAD_DEB_REPO" ]; then
        echo -e "Envoronment UPLOAD_DEB_REPO hasn't been defined. Please export it to continue..."
        exit 1
fi
		for i in `ls -1 *.deb`; do
			echo $i
			curl -u $UPLOAD_USER:$UPLOAD_PASSWORD -X POST -H "Content-Type: multipart/form-data" --data-binary @$i $UPLOAD_DEB_REPO
		done
		

help(){
	echo -e "Usage: $0 deb  --- To upload debian package\n Environment variables: \n\t UPLOAD_USER & UPLOAD_PASSWORD - username and password used for upload \n\t UPLOAD_DEB_REPO - remote or local debain repository"
}

