#!/usr/bin/env bash
KEY_ID=$KEY_ID
KEY_SECRET=$KEY_SECRET
DATE=`date -u -R`
echo ${DATE}
OUTFILE="outkey-copy"
SOURCEFILE="/kmnt/outkey"
BUCKET="kmnt"
relativePath="/${BUCKET}/${OUTFILE}"
contentType="application/octet-stream"
ContentMD5=""
#字典序
stringToSign="PUT\n${ContentMD5}\n${contentType}\n${DATE}\nx-amz-acl:private\nx-amz-copy-source:${SOURCEFILE}\nx-amz-metadata-directive:COPY\n${relativePath}"
signature=`echo -en ${stringToSign} | openssl sha1 -hmac ${KEY_SECRET} -binary | base64`
echo ${signature}
HOST="$BUCKET.$OBSHOST"
curl -s -v -X PUT http://${HOST}/${OUTFILE} \
-H "Authorization: AWS ${KEY_ID}:${signature}" \
-H "Date: ${DATE}" \
-H "Host: ${HOST}" \
-H "Content-Type: ${contentType}" \
-H "x-amz-copy-source: ${SOURCEFILE}" \
-H "x-amz-metadata-directive: COPY" \
-H "x-amz-acl: private" \
-T "key"
