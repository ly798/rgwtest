#!/usr/bin/env bash
#设置bucket可以匿名访问
KEY_ID=$KEY_ID
KEY_SECRET=$KEY_SECRET
DATE=`date -u -R`

BUCKET="test-bucket"
contentType=""
ContentMD5=""
x_amz_acl="private"

stringToSign="PUT\n${ContentMD5}\n${contentType}\n${DATE}\nx-amz-acl:${x_amz_acl}\n/$BUCKET/?acl"
signature=`echo -en ${stringToSign} | openssl sha1 -hmac ${KEY_SECRET} -binary | base64`

HOST="$BUCKET.$OBSHOST"
uri="http://${HOST}/?acl"

curl -s -v -X PUT ${uri} \
-H "Authorization: AWS ${KEY_ID}:${signature}" \
-H "Date: ${DATE}" \
-H "Host: ${HOST}" \
-H "Content-Type: ${contentType}" \
-H "x-amz-acl: ${x_amz_acl}"