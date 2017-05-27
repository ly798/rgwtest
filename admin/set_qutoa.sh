#!/usr/bin/env bash
KEY_ID=$KEY_ID
KEY_ID=$KEY_SECRET
DATE=`date -u -R`

contentType="application/json"
ContentMD5=""
relativePath="/admin/user"
body='{"max_objects": "2", "enabled": "true", "bucket": "qutoatest", "quota-scope": "user", "max_size_kb": "10485"}'

#字典序
stringToSign="PUT\n${ContentMD5}\n${contentType}\n${DATE}\n${relativePath}"

signature=`echo -en ${stringToSign} | openssl sha1 -hmac ${KEY_SECRET} -binary | base64`

HOST=$OBSHOST

param="?uid=qutoa&quota&quota-type=bucket"
curl -s -v -X PUT "http://${HOST}${relativePath}${param}" \
-H "Authorization: AWS ${KEY_ID}:${signature}" \
-H "Date: ${DATE}" \
-H "Host: ${HOST}" \
-H "Content-Type: ${contentType}" \
-d "${body}"

## 或者不传 contentType，即设置 contentType 为空，那么 header 中也不要传 Content-Type

#PUT /admin/user?uid=testuser1&quota&quota-type=user HTTP/1.1
#Host: $OBSHOST
#User-Agent: curl/7.43.0
#Accept: */*
#Authorization: AWS AD0AU129OFPJUGWDQ2QD:3kvseWBFCvMS3c6wRdjSYkl1aJw=
#Date: Fri, 29 Jan 2016 03:35:57 +0000
#Content-Type: application/json
#Content-Length: 110

#{"max_objects": "100", "enabled": "true", "bucket": "testobs1", "quota-scope": "user", "max_size_kb": "10000"}

#################################

#PUT /admin/user?uid=testuser1&quota&quota-type=user HTTP/1.1
#Host: $OBSHOST
#Content-Length: 110
#Accept-Encoding: gzip, deflate
#Accept: */*
#User-Agent: python-requests/2.7.0 CPython/2.7.10 Linux/4.2.0-25-generic
#Connection: keep-alive
#date: Fri, 29 Jan 2016 03:35:54 GMT
#Authorization: AWS 8XHJDGE7265UBJP43DIT:zYuzavz7v1E0a6/UEnWP0Qf4KUs=

#{"max_objects": "100", "enabled": "true", "bucket": "testobs1", "quota-scope": "user", "max_size_kb": "10000"}