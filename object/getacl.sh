#!/usr/bin/env bash
KEY_ID=$KEY_ID
KEY_SECRET=$KEY_SECRET
DATE=`date -u -R`
FILE="outkey"
BUCKET="kmnt"
relativePath="/${BUCKET}/${FILE}"
contentType="application/octet-stream"
ContentMD5=""
stringToSign="GET\n${ContentMD5}\n${contentType}\n${DATE}\n${relativePath}?acl"
signature=`echo -en ${stringToSign} | openssl sha1 -hmac ${KEY_SECRET} -binary | base64`
HOST="$BUCKET.$OBSHOST"
curl -s -v -X GET "http://${HOST}/${FILE}?acl" \
-H "Authorization: AWS ${KEY_ID}:${signature}" \
-H "Date: ${DATE}" \
-H "Host: ${HOST}" \
-H "Content-Type: ${contentType}"