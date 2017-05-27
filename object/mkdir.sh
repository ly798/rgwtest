#!/usr/bin/env bash
KEY_ID=$KEY_ID
KEY_SECRET=$KEY_SECRET
DATE=`date -u -R`

#str="五"
str="%E4%BA%94"
#str="a"
for((i=1;i<=254;i++)); do
   str1="${str1}""${str}"
done
#echo ${#str1}

for((i=1;i<=50;i++)); do
   str2="${str2}""${str}"
done

OUTFILE="${str1}/"
OUTFILE="${str1}/${str2}/"
BUCKET="foldtest"
relativePath="/${BUCKET}/${OUTFILE}"
contentType=""
ContentMD5=""
#字典序
stringToSign="PUT\n${ContentMD5}\n${contentType}\n${DATE}\n${relativePath}"
signature=`echo -en ${stringToSign} | openssl sha1 -hmac ${KEY_SECRET} -binary | base64`

HOST="$BUCKET.$OBSHOST"
curl -s -v -X PUT "http://${HOST}/${OUTFILE}" \
-H "Authorization: AWS ${KEY_ID}:${signature}" \
-H "Date: ${DATE}" \
-H "Host: ${HOST}" \
-H "Content-Length: 0"


