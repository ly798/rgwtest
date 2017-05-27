#!/usr/bin/env bash
KEY_ID=$KEY_ID
KEY_SECRET=$KEY_SECRET
DATE=`date -u -R`
echo ${DATE}

BUCKET="mybucket"
contentType=""
ContentMD5=""
body='
   "Version": "2012-10-17",
   "Id": "123",
   "Statement": [
     {
       "Sid": "",
       "Effect": "Deny",
       "Principal": "*",
       "Action": "s3:*",
       "Resource": "arn:aws:s3:::examplebucket/taxdocuments/*",
       "Condition": { "Null": { "aws:MultiFactorAuthAge": true }}
     }
   ]
}'

#字典序
stringToSign="POST\n${ContentMD5}\n${contentType}\n${DATE}\n/$BUCKET/?policy"
echo ${stringToSign}

signature=`echo -en ${stringToSign} | openssl sha1 -hmac ${KEY_SECRET} -binary | base64`
echo ${signature}

HOST="$BUCKET.$OBSHOST"
uri="http://${HOST}/?policy"
echo ${uri}

curl -s -v -X POST ${uri} \
-H "Authorization: AWS ${KEY_ID}:${signature}" \
-H "Date: ${DATE}" \
-H "Host: ${HOST}" \
-d ${body}