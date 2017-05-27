#!/usr/bin/env bash
KEY_ID=$KEY_ID
KEY_SECRET=$KEY_SECRET
DATE=`date -u -R`
echo ${DATE}
FILE="part"
BUCKET="kmnt"
relativePath="/${BUCKET}/${FILE}"
contentType="application/octet-stream"
ContentMD5=""
source="/${BUCKET}/outkey"
#字典序
stringToSign="PUT\n${ContentMD5}\n${contentType}\n${DATE}\nx-amz-copy-source:${source}\n${relativePath}?partNumber=3&uploadId=2/MCoYUTklEqgXfEjy4coMRYRpOYEc_V3"
signature=`echo -en ${stringToSign} | openssl sha1 -hmac ${KEY_SECRET} -binary | base64`
echo ${signature}
HOST="$BUCKET.$OBSHOST"
curl -s -v -X PUT "http://${HOST}/${FILE}?partNumber=3&uploadId=2/MCoYUTklEqgXfEjy4coMRYRpOYEc_V3" \
-H "Authorization: AWS ${KEY_ID}:${signature}" \
-H "Date: ${DATE}" \
-H "Host: ${HOST}" \
-H "Content-Type: ${contentType}" \
-H "x-amz-copy-source: ${source}"