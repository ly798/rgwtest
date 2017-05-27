#!/usr/bin/env bash
KEY_ID=$KEY_ID
KEY_SECRET=$KEY_SECRET
DATE=`date -u -R`

BUCKET="corstest"
contentType=""
ContentMD5=""

stringToSign="OPTIONS\n${ContentMD5}\n${contentType}\n${DATE}\n/${BUCKET}/?cors"
signature=`echo -en ${stringToSign} | openssl sha1 -hmac ${KEY_SECRET} -binary | base64`

HOST="${BUCKET}.$OBSHOST"
uri="http://${HOST}/?cors"

curl -s -v -X OPTIONS "${uri}" \
-H "Authorization: AWS ${KEY_ID}:${signature}" \
-H "Date: ${DATE}" \
-H "Host: ${HOST}" \
-H "Origin: www.eayun.com" \
-H "Access-Control-Request-Method: PUT"
