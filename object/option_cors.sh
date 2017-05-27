#!/usr/bin/env bash
KEY_ID=$KEY_ID
KEY_SECRET=$KEY_SECRET
DATE=`date -u -R`

BUCKET="corstest"
FILE="anaconda-ks.cfg"
relativePath="/${BUCKET}/${FILE}"
contentType=""
ContentMD5=""

stringToSign="OPTIONS\n${ContentMD5}\n${contentType}\n${DATE}\n${relativePath}"
signature=`echo -en ${stringToSign} | openssl sha1 -hmac ${KEY_SECRET} -binary | base64`

HOST="${BUCKET}.$OBSHOST"
uri="http://${HOST}/${FILE}"

curl -s -v -X OPTIONS "${uri}" \
-H "Authorization: AWS ${KEY_ID}:${signature}" \
-H "Date: ${DATE}" \
-H "Host: ${HOST}" \
-H "Origin: null" \
-H "Access-Control-Request-Method: GET"
