#!/usr/bin/env bash
KEY_ID=$KEY_ID
KEY_SECRET=$KEY_SECRET
DATE=`date -u -R`
FILE="test"
BUCKET="my-bucket"
relativePath="/${BUCKET}/${FILE}"
contentType="application/octet-stream"
ContentMD5=""
#字典序
stringToSign="POST\n${ContentMD5}\n${contentType}\n${DATE}\n${relativePath}?uploads"
signature=`echo -en ${stringToSign} | openssl sha1 -hmac ${KEY_SECRET} -binary | base64`
#echo ${signature}
HOST="$BUCKET.$OBSHOST"
curl -s -v -X POST http://${HOST}/${FILE}?uploads \
-H "Authorization: AWS ${KEY_ID}:${signature}" \
-H "Date: ${DATE}" \
-H "Host: ${HOST}" \
-H "Content-Type: ${contentType}"