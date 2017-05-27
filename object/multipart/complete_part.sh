#!/usr/bin/env bash
KEY_ID=$KEY_ID
KEY_SECRET=$KEY_SECRET
DATE=`date -u -R`
echo ${DATE}
FILE="test"
BUCKET="my-bucket"
relativePath="/${BUCKET}/${FILE}"
contentType="application/octet-stream"
ContentMD5=""
body='<CompleteMultipartUpload>
<Part>
<PartNumber>1</PartNumber>
<ETag>d41d8cd98f00b204e9800998ecf8427e</ETag>
</Part>
<Part>
<PartNumber>2</PartNumber>
<ETag>d41d8cd98f00b204e9800998ecf8427e</ETag>
</Part>
<Part>
<PartNumber>3</PartNumber>
<ETag>a8fb0a509b3faab37cb5620504905e4a</ETag>
</Part>
</CompleteMultipartUpload>'
#字典序
stringToSign="POST\n${ContentMD5}\n${contentType}\n${DATE}\n${relativePath}?uploadId=2/lOQEuBY1nMjVA5pa15sPtOHMRwEk__a"
signature=`echo -en ${stringToSign} | openssl sha1 -hmac ${KEY_SECRET} -binary | base64`
echo ${signature}
HOST="$BUCKET.$OBSHOST"
curl -s -v -X POST "http://${HOST}/${FILE}?uploadId=2/lOQEuBY1nMjVA5pa15sPtOHMRwEk__a" \
-H "Authorization: AWS ${KEY_ID}:${signature}" \
-H "Date: ${DATE}" \
-H "Host: ${HOST}" \
-H "Content-Type: ${contentType}" \
-d "${body}"

#debug message
#*   Trying 182.150.27.112...
#* Connected to my-bucket.obs.eayun.com (182.150.27.112) port 9090 (#0)
#> POST /test?uploadId=2/lOQEuBY1nMjVA5pa15sPtOHMRwEk__a HTTP/1.1
#> Host: my-bucket.$OBSHOST
#> User-Agent: curl/7.43.0
#> Accept: */*
#> Authorization: AWS G7HGAZI01NOYBNWQ4EJD:me9pBsv/dlNDjpq9Ry+GaLjr864=
#> Date: Mon, 22 Feb 2016 09:43:10 +0000
#> Content-Type: application/octet-stream
#> Content-Length: 316
#>
#} [316 bytes data]
#* upload completely sent off: 316 out of 316 bytes
#< HTTP/1.1 400
#< Date: Mon, 22 Feb 2016 09:43:10 GMT
#< Server: Apache/2.4.6 (CentOS) OpenSSL/1.0.1e-fips
#< Accept-Ranges: bytes
#< Content-Length: 80
#< Connection: close
#< Content-Type: application/xml
#< Set-Cookie: RADOSGWLB=ceph2; path=/
#<
#{ [80 bytes data]
#* Closing connection 0
#<?xml version="1.0" encoding="UTF-8"?><Error><Code>EntityTooSmall</Code></Error>