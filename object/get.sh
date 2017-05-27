#!/usr/bin/env bash
KEY_ID=$KEY_ID
KEY_SECRET=$KEY_SECRET
DATE=`date -u -R`
echo $DATE
FILE="outkey"
BUCKET="kmnt"
relativePath="/${BUCKET}/${FILE}"
contentType="application/octet-stream"
ContentMD5=""
#字典序
stringToSign="GET\n${ContentMD5}\n${contentType}\n${DATE}\n${relativePath}?response-content-type=text/plain"
signature=`echo -en ${stringToSign} | openssl sha1 -hmac ${KEY_SECRET} -binary | base64`
echo ${signature}
HOST="$BUCKET.$OBSHOST"
curl -s -v -X GET http://${HOST}/${FILE}?response-content-type=text/plain \
-H "Authorization: AWS ${KEY_ID}:${signature}" \
-H "Date: ${DATE}" \
-H "Host: ${HOST}" \
-H "Content-Type: ${contentType}" \
-H "Range: bytes=0-10" #Range不需要进行请求构造、base64等
#-H "x-amz-metadata-directive: COPY" \
#-H "x-amz-acl: private" \
#-T "key"
