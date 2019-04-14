#!/bin/bash
case $1 in
	deb)
		curl -u $UPLOAD_USER:$UPLOAD_PASSWORD -X POST -H "Content-Type: multipart/form-data" --data-binary @$i $DEB_REPO
	;;
	*)
		echo -e "Usage: $0 deb  --- To upload debian package\n Environment variables: \n\t UPLOAD_USER & UPLOAD_PASSWORD - username and password used for upload \n\t DEB_REPO - remote or local debain repository"
	;;
esac