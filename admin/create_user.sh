#!/usr/bin/env bash
#admin
KEY_ID=$KEY_ID
KEY_ID=$KEY_SECRET
DATE=`date -u -R`
#echo $DATE
#start="2015-12-30%2020%3A00%3A00"
relativePath="/admin/user"
#echo ${relativePath}
contentType=""
ContentMD5=""
#字典序
stringToSign="PUT\n${ContentMD5}\n${contentType}\n${DATE}\n${relativePath}"
signature=`echo -en ${stringToSign} | openssl sha1 -hmac ${KEY_SECRET} -binary | base64`
HOST=$OBSHOST
#?start=${start}&show-entries=true&show-summary=false
curl -s -v -X PUT "http://${HOST}${relativePath}?uid=sameuser&display-name=sameuser" \
-H "Authorization: AWS ${KEY_ID}:${signature}" \
-H "Date: ${DATE}" \
-H "Host: ${HOST}"