#!/usr/bin/env bash
KEY_ID=$KEY_ID
KEY_SECRET=$KEY_SECRET
DATE=`date -u -R`
echo $DATE
FILE="outkey"
BUCKET="kmnt"
relativePath="/${BUCKET}/${FILE}"
contentType="application/octet-stream"
ContentMD5=""
#字典序
stringToSign="PUT\n${ContentMD5}\n${contentType}\n${DATE}\n${relativePath}?acl"
signature=`echo -en ${stringToSign} | openssl sha1 -hmac ${KEY_SECRET} -binary | base64`
echo ${signature}
HOST="$BUCKET.$OBSHOST"
reqcon='<AccessControlPolicy xmlns="http://s3.amazonaws.com/doc/2006-03-01/">
<Owner><ID>testuser</ID><DisplayName>testuser</DisplayName></Owner>
<AccessControlList>
<Grant>
<Grantee xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="CanonicalUser">
<ID>testuser</ID><DisplayName>testuser</DisplayName>
</Grantee>
<Permission>READ</Permission>
</Grant>
</AccessControlList>
</AccessControlPolicy>'
curl -s -v -X PUT http://${HOST}/${FILE}?acl \
-H "Authorization: AWS ${KEY_ID}:${signature}" \
-H "Date: ${DATE}" \
-H "Host: ${HOST}" \
-H "Content-Type: ${contentType}" \
-d "${reqcon}"