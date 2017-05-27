#!/usr/bin/env bash
#TODO          like get_bucket_list.sh
KEY_ID=$KEY_ID
KEY_SECRET=$KEY_SECRET
BUCKET="public"
contentType=""
ContentMD5=""

param="location"

stringToSign="GET\n${ContentMD5}\n${contentType}\n${DATE}\n/${BUCKET}/?${param}"
signature=`echo -en ${stringToSign} | openssl sha1 -hmac ${KEY_SECRET} -binary | base64`

HOST="$BUCKET.$OBSHOST"
uri="http://${HOST}/?${param}"

curl -s -v -X GET ${uri} \
-H "Authorization: AWS ${KEY_ID}:${signature}" \
-H "Date: ${DATE}" \
-H "Host: ${HOST}"