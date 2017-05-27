#!/usr/bin/env bash
KEY_ID=$KEY_ID
KEY_SECRET=$KEY_SECRET
DATE=`date -u -R`
#echo ${DATE}
FILE="test"
BUCKET="my-bucket"
relativePath="/${BUCKET}/${FILE}"
contentType="application/octet-stream"
ContentMD5=""
#字典序
stringToSign="GET\n${ContentMD5}\n${contentType}\n${DATE}\n${relativePath}?uploadId=2/lOQEuBY1nMjVA5pa15sPtOHMRwEk__a"
signature=`echo -en ${stringToSign} | openssl sha1 -hmac ${KEY_SECRET} -binary | base64`
#echo ${signature}
HOST="$BUCKET.$OBSHOST"
curl -s -X GET "http://${HOST}/${FILE}?uploadId=2/lOQEuBY1nMjVA5pa15sPtOHMRwEk__a" \
-H "Authorization: AWS ${KEY_ID}:${signature}" \
-H "Date: ${DATE}" \
-H "Host: ${HOST}" \
-H "Content-Type: ${contentType}" | xmllint --format -