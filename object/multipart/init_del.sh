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
#字典序
stringToSign="DELETE\n${ContentMD5}\n${contentType}\n${DATE}\n${relativePath}?uploadId=2/3ZsLN-NfIIov8iwymtK-cd895jVGkr5"
signature=`echo -en ${stringToSign} | openssl sha1 -hmac ${KEY_SECRET} -binary | base64`
echo ${signature}
HOST="$BUCKET.$OBSHOST"
curl -s -v -X DELETE "http://${HOST}/${FILE}?uploadId=2/3ZsLN-NfIIov8iwymtK-cd895jVGkr5" \
-H "Authorization: AWS ${KEY_ID}:${signature}" \
-H "Date: ${DATE}" \
-H "Host: ${HOST}" \
-H "Content-Type: ${contentType}"