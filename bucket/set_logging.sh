#!/usr/bin/env bash
#TODO faild
KEY_ID=$KEY_ID
KEY_SECRET=$KEY_SECRET
DATE=`date -u -R`
BUCKET="public"
contentType=""
ContentMD5=""
reqcon='<?xml version="1.0" encoding="UTF-8"?>
<BucketLoggingStatus xmlns="http://doc.s3.amazonaws.com/2006-03-01">
  <LoggingEnabled>
    <TargetBucket>public</TargetBucket>
    <TargetPrefix>public-access_log-/</TargetPrefix>
    <TargetGrants>
      <Grant>
        <Grantee xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="CanonicalUser">
            <ID>lyang</ID>
            <DisplayName>lyang</DisplayName>
        </Grantee>
        <Permission>READ</Permission>
      </Grant>
    </TargetGrants>
  </LoggingEnabled>
</BucketLoggingStatus>'

param="logging"

stringToSign="PUT\n${ContentMD5}\n${contentType}\n${DATE}\n/$BUCKET/?${param}"
signature=`echo -en ${stringToSign} | openssl sha1 -hmac ${KEY_SECRET} -binary | base64`

HOST="$BUCKET.$OBSHOST"
uri="http://${HOST}/?${param}"

curl -s -v -X PUT ${uri} \
-H "Authorization: AWS ${KEY_ID}:${signature}" \
-H "Date: ${DATE}" \
-H "Host: ${HOST}" \
-d "${reqcon}"