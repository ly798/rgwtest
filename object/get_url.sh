#!/usr/bin/env bash
KEY_ID=$KEY_ID
KEY_SECRET=$KEY_SECRET

FILE="hello"
BUCKET="kmnt"
relativePath="/${BUCKET}/${FILE}"
contentType=""
ContentMD5=""

# Unix timestamp,过期时刻的 timestamp
# timeStamp="1453136400"
current=`date "+%Y-%m-%d %H:%M:%S"`
timeStamp=`date -d "$current" +%s`      #将current转换为时间戳，精确到秒
echo ${timeStamp}

stringToSign="GET\n${ContentMD5}\n${contentType}\n${timeStamp}\n${relativePath}"

signature=`echo -en ${stringToSign} | openssl sha1 -hmac ${KEY_SECRET} -binary | base64`

HOST="${BUCKET}.$OBSHOST/${FILE}"
echo "http://${HOST}?AWSAccessKeyId=${KEY_ID}&Expires=${timeStamp}&Signature=${signature}"