#!/usr/bin/env bash
#admin
KEY_ID=$KEY_ID
KEY_ID=$KEY_SECRET
DATE=`date -u -R`

start="2016-02-22%2016%3A00%3A00"   #2016-02-22 00:00:00
relativePath="/admin/usage"
end="2016-02-22%2018%3A00%3A00"

contentType=""
ContentMD5=""
#字典序
stringToSign="GET\n${ContentMD5}\n${contentType}\n${DATE}\n${relativePath}"
signature=`echo -en ${stringToSign} | openssl sha1 -hmac ${KEY_SECRET} -binary | base64`
HOST=$OBSHOST
#?start=${start}&show-entries=true&show-summary=false
curl -s -v -X GET "http://${HOST}${relativePath}?start=${start}&end=${end}&uid=cusid1" \
-H "Authorization: AWS ${KEY_ID}:${signature}" \
-H "Date: ${DATE}" \
-H "Host: ${HOST}"