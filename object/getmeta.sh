#!/usr/bin/env bash
KEY_ID=$KEY_ID
KEY_SECRET=$KEY_SECRET
DATE=`date -u -R`
echo $DATE
FILE="hello"
#FILE="4d3b1fc1-b926-4eb3-9727-8c94024eaee5"
BUCKET="kmnt"
#BUCKET="c52b54b8-bb0a-47a7-883b-1b8f9ffb9ad9"
relativePath="/${BUCKET}/${FILE}"
contentType="application/octet-stream"
ContentMD5=""
#字典序
stringToSign="HEAD\n${ContentMD5}\n${contentType}\n${DATE}\n${relativePath}"
signature=`echo -en ${stringToSign} | openssl sha1 -hmac ${KEY_SECRET} -binary | base64`
echo ${signature}
HOST="$BUCKET.$OBSHOST"
curl -s -v -X HEAD http://${HOST}/${FILE} \
-H "Authorization: AWS ${KEY_ID}:${signature}" \
-H "Date: ${DATE}" \
-H "Host: ${HOST}" \
-H "Content-Type: ${contentType}"