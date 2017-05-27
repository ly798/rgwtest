#!/usr/bin/env bash
KEY_ID=$KEY_ID
KEY_SECRET=$KEY_SECRET
DATE=`date -u -R`

BUCKET="test-bucket"
contentType=""
ContentMD5=""

#字典序
stringToSign="GET\n${ContentMD5}\n${contentType}\n${DATE}\n/$BUCKET/?acl"

signature=`echo -en ${stringToSign} | openssl sha1 -hmac ${KEY_SECRET} -binary | base64`

HOST="$BUCKET.$OBSHOST"
uri="http://${HOST}/?acl"

curl -s -v -X GET ${uri} \
-H "Authorization: AWS ${KEY_ID}:${signature}" \
-H "Date: ${DATE}" \
-H "Host: ${HOST}" | xmllint --format -