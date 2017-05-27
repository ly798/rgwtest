#!/usr/bin/env bash
KEY_ID=$KEY_ID
KEY_ID=$KEY_SECRET
DATE=`date -u -R`

contentType=""
ContentMD5=""

relativePath="/admin/log"
#字典序
stringToSign="GET\n${ContentMD5}\n${contentType}\n${DATE}\n${relativePath}"

signature=`echo -en ${stringToSign} | openssl sha1 -hmac ${KEY_SECRET} -binary | base64`

HOST=$OBSHOST
# %20 空格转义
param="?marker=%20&type=metadata&id=0&max-entries=1000"

curl -s -X GET "http://${HOST}${relativePath}${param}" \
    -H "Authorization: AWS ${KEY_ID}:${signature}" \
    -H "Date: ${DATE}" \
    -H "Host: ${HOST}"