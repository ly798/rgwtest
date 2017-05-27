#!/usr/bin/env bash
KEY_ID=$KEY_ID
KEY_SECRET=$KEY_SECRET
DATE=`date -u -R`
FILE="test"
BUCKET="my-bucket"
relativePath="/${BUCKET}/${FILE}"
contentType="application/octet-stream"
ContentMD5=""

x_amz_date=${DATE}
DATE=""     #清空DATE

stringToSign="POST\n${ContentMD5}\n${contentType}\n${DATE}\nx-amz-date:${x_amz_date}\n${relativePath}?uploads"
signature=`echo -en ${stringToSign} | openssl sha1 -hmac ${KEY_SECRET} -binary | base64`
echo ${signature}
HOST="$BUCKET.$OBSHOST"
curl -s -v -X POST http://${HOST}/${FILE}?uploads \
-H "Authorization: AWS ${KEY_ID}:${signature}" \
-H "Host: ${HOST}" \
-H "x-amz-date: ${x_amz_date}" \
-H "Content-Type: ${contentType}"