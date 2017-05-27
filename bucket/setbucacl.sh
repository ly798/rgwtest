#!/usr/bin/env bash
#设置bucket可以匿名访问
KEY_ID=$KEY_ID
KEY_SECRET=$KEY_SECRET
DATE=`date -u -R`

BUCKET="public"
contentType="application/xml"
ContentMD5=""
reqc="<AccessControlPolicy xmlns=\"http://s3.amazonaws.com/doc/2006-03-01/\">
<Owner><ID>testuser</ID><DisplayName>testuser</DisplayName></Owner>
  <AccessControlList>
    <Grant>
      <Grantee xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:type=\"Group\">
      <URI>http://acs.amazonaws.com/groups/global/AllUsers</URI>
      </Grantee>
      <Permission>FULL_CONTROL</Permission>
    </Grant>
    <Grant>
      <Grantee xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:type=\"CanonicalUser\">
      <ID>testuser</ID>
      <DisplayName>testuser</DisplayName>
      </Grantee>
      <Permission>FULL_CONTROL</Permission>
    </Grant>
    <Grant>
      <Grantee xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:type=\"Group\">
      <URI>http://acs.amazonaws.com/groups/global/AllUsers</URI>
      </Grantee>
      <Permission>FULL_CONTROL</Permission>
    </Grant>
  </AccessControlList>
</AccessControlPolicy>"

stringToSign="PUT\n${ContentMD5}\n${contentType}\n${DATE}\n/$BUCKET/?acl"

signature=`echo -en ${stringToSign} | openssl sha1 -hmac ${KEY_SECRET} -binary | base64`

HOST="$BUCKET.$OBSHOST"
uri="http://${HOST}/?acl"

curl -s -v -X PUT ${uri} \
-H "Authorization: AWS ${KEY_ID}:${signature}" \
-H "Date: ${DATE}" \
-H "Host: ${HOST}" \
-H "Content-Type: ${contentType}" \
-d "${reqc}"