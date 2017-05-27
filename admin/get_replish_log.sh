#!/usr/bin/env bash
KEY_ID=$KEY_ID
KEY_ID=$KEY_SECRET
DATE=`date -u -R`

contentType=""
ContentMD5=""
relativePath="/admin/replica_log"

#字典序
stringToSign="GET\n${ContentMD5}\n${contentType}\n${DATE}\n${relativePath}"

signature=`echo -en ${stringToSign} | openssl sha1 -hmac ${KEY_SECRET} -binary | base64`

HOST=$OBSHOST
# -v
i=0
while(($i<150))
do
    #param="?bounds&type=metadata&id=${i}"
    param="?bounds&type=data&id=${i}"
    echo "http://${HOST}${relativePath}${param}"
    curl -s -X GET "http://${HOST}${relativePath}${param}" \
    -H "Authorization: AWS ${KEY_ID}:${signature}" \
    -H "Date: ${DATE}" \
    -H "Host: ${HOST}"
    i=$(($i+1))
    echo
done


