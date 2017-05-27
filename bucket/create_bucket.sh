#!/usr/bin/env bash
KEY_ID=$KEY_ID
KEY_SECRET=$KEY_SECRET
DATE=`date -u -R`
echo ${DATE}
BUCKET="demo"
contentType=""
ContentMD5=""
#字典序
stringToSign="PUT\n${ContentMD5}\n${contentType}\n${DATE}\n/${BUCKET}/"
echo ${stringToSign}
signature=`echo -en ${stringToSign} | openssl sha1 -hmac ${KEY_SECRET} -binary | base64`
echo ${signature}
HOST="$BUCKET.$OBSHOST"
curl -s -v -X PUT "http://${HOST}/" \
-H "Authorization: AWS ${KEY_ID}:${signature}" \
-H "Date: ${DATE}" \
-H "Host: ${HOST}"
