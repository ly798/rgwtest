#!/usr/bin/env bash
KEY_ID=$KEY_ID
KEY_SECRET=$KEY_SECRET
DATE=`date -u -R`
echo ${DATE}

BUCKET="demo"
contentType=""
ContentMD5=""

#字典序
stringToSign="PUT\n${ContentMD5}\n${contentType}\n${DATE}\n/$BUCKET?versioning"
echo ${stringToSign}

signature=`echo -en ${stringToSign} | openssl sha1 -hmac ${KEY_SECRET} -binary | base64`
echo ${signature}

HOST="$BUCKET.$OBSHOST"
uri="http://${HOST}/?versioning"
echo ${uri}

curl -s -v -X PUT ${uri} \
-H "Authorization: AWS ${KEY_ID}:${signature}" \
-H "Date: ${DATE}" \
-H "Host: ${HOST}" \
-d "<VersioningConfiguration xmlns="http://s3.amazonaws.com/doc/2006-03-01/">
  <Status>Enabled</Status>
</VersioningConfiguration>"