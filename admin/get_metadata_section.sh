#!/usr/bin/env bash
# 对应的是 radosgw-admin metadata list
KEY_ID=$KEY_ID
KEY_ID=$KEY_SECRET
DATE=`date -u -R`

contentType=""
ContentMD5=""

relativePath="/admin/metadata"
#字典序
stringToSign="GET\n${ContentMD5}\n${contentType}\n${DATE}\n${relativePath}"

signature=`echo -en ${stringToSign} | openssl sha1 -hmac ${KEY_SECRET} -binary | base64`

HOST=$OBSHOST

curl -s -X GET "http://${HOST}${relativePath}" \
    -H "Authorization: AWS ${KEY_ID}:${signature}" \
    -H "Date: ${DATE}" \
    -H "Host: ${HOST}"