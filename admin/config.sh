#!/usr/bin/env bash
#同 radosgw-admin regionmap get 、radosgw-admin region-map get
KEY_ID=$KEY_ID
KEY_ID=$KEY_SECRET
DATE=`date -u -R`

contentType=""
ContentMD5=""
relativePath="/admin/config"

#字典序
stringToSign="GET\n${ContentMD5}\n${contentType}\n${DATE}\n${relativePath}"

signature=`echo -en ${stringToSign} | openssl sha1 -hmac ${KEY_SECRET} -binary | base64`

HOST=$OBSHOST

curl -s -v -X GET "http://${HOST}${relativePath}" \
-H "Authorization: AWS ${KEY_ID}:${signature}" \
-H "Date: ${DATE}" \
-H "Host: ${HOST}"