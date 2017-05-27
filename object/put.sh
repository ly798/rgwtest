#!/usr/bin/env bash
KEY_ID=$KEY_ID
KEY_SECRET=$KEY_SECRET
DATE=`date -u -R`
echo ${DATE}
OUTFILE="outkey"
BUCKET="kmnt"
relativePath="/${BUCKET}/${OUTFILE}"
contentType="application/octet-stream"
ContentMD5=""
#字典序
stringToSign="PUT\n${ContentMD5}\n${contentType}\n${DATE}\nx-amz-acl:private\nx-amz-meta-test:test meta\n${relativePath}"
signature=`echo -en ${stringToSign} | openssl sha1 -hmac ${KEY_SECRET} -binary | base64`
echo ${signature}
#HOST="$BUCKET.$OBSHOST"
HOST="182.150.27.112:9090"
HOST_PATHSTYLE="$HOST/$BUCKET"
curl -s -v -X PUT http://${HOST_PATHSTYLE}/${OUTFILE} \
-H "Authorization: AWS ${KEY_ID}:${signature}" \
-H "Date: ${DATE}" \
-H "Host: ${HOST}" \
-H "Content-Type: ${contentType}" \
-H "x-amz-meta-test: test meta" \
-H "x-amz-acl: private" \
-T  "key"
