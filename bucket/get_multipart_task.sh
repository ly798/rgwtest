#!/usr/bin/env bash
KEY_ID=$KEY_ID
KEY_SECRET=$KEY_SECRET
#KEY_ID="8XHJDGE7265UBJP43DIT"
#KEY_SECRET="jDfwCHMrFsz0IKwnYDm44dUNa0AzoWZU7i7ur7XH"
DATE=`date -u -R`
BUCKET="my-bucket"
contentType=""
ContentMD5=""
param="uploads"

stringToSign="GET\n${ContentMD5}\n${contentType}\n${DATE}\n/$BUCKET/?${param}"
signature=`echo -en ${stringToSign} | openssl sha1 -hmac ${KEY_SECRET} -binary | base64`
HOST="$BUCKET.$OBSHOST"
uri="http://${HOST}/?${param}"
curl -s -v -X GET ${uri} \
-H "Authorization: AWS ${KEY_ID}:${signature}" \
-H "Date: ${DATE}" \
-H "Host: ${HOST}"