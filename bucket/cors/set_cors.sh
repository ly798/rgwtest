#!/usr/bin/env bash
KEY_ID=$KEY_ID
KEY_SECRET=$KEY_SECRET
DATE=`date -u -R`

BUCKET="corstest"
contentType="application/xml"

reqcon="<CORSConfiguration>
  <CORSRule>
    <AllowedMethod>POST</AllowedMethod>
    <AllowedMethod>GET</AllowedMethod>
    <AllowedMethod>HEAD</AllowedMethod>
    <AllowedMethod>PUT</AllowedMethod>
    <AllowedMethod>DELETE</AllowedMethod>
    <AllowedOrigin>*.eayun.com</AllowedOrigin>
    <AllowedHeader>AllowedHeader_1</AllowedHeader>
    <AllowedHeader>AllowedHeader_2</AllowedHeader>
    <MaxAgeSeconds>100</MaxAgeSeconds>
    <ExposeHeader>ExposeHeader_1</ExposeHeader>
    <ExposeHeader>ExposeHeader_2</ExposeHeader>
  </CORSRule>
</CORSConfiguration>"

ContentMD5=`echo -n ${reqcon} | md5sum | base64`

stringToSign="PUT\n${ContentMD5}\n${contentType}\n${DATE}\n/${BUCKET}/?cors"
signature=`echo -en ${stringToSign} | openssl sha1 -hmac ${KEY_SECRET} -binary | base64`

HOST="${BUCKET}.$OBSHOST"
uri="http://${HOST}/?cors"

curl -s -v -X PUT "${uri}" \
-H "Authorization: AWS ${KEY_ID}:${signature}" \
-H "Date: ${DATE}" \
-H "Host: ${HOST}" \
-H "Content-MD5: ${ContentMD5}" \
-H "Content-Type: ${contentType}" \
-d "${reqcon}"


#####注意
# Content-Type: ${contentType} 必须设置