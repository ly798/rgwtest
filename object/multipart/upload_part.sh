#!/usr/bin/env bash
KEY_ID=$KEY_ID
KEY_SECRET=$KEY_SECRET
DATE=`date -u -R`
echo ${DATE}
FILE="test"
upfile="/home/yippee/pycharm-professional-2016.1.2.tar.gz"
BUCKET="my-bucket"
relativePath="/${BUCKET}/${FILE}"
contentType="application/octet-stream"
ContentMD5=""
uploadId="2/UBe2N4-RTHoffB7UtYeOeSIPd6aWRpb"
#字典序
stringToSign="PUT\n${ContentMD5}\n${contentType}\n${DATE}\n${relativePath}?partNumber=1&uploadId=${uploadId}"
signature=`echo -en ${stringToSign} | openssl sha1 -hmac ${KEY_SECRET} -binary | base64`
echo ${signature}
HOST="$BUCKET.$OBSHOST"
curl -s -v -X PUT "http://${HOST}/${FILE}?partNumber=1&uploadId=${uploadId}" \
-H "Authorization: AWS ${KEY_ID}:${signature}" \
-H "Date: ${DATE}" \
-H "Host: ${HOST}" \
-H "Content-Type: ${contentType}" \
-H "Content-Length: 0" \
-T ${upfile}

# 指定 Content-Length: 0 可上传空的段

# debug message
#*   Trying 182.150.27.112...
#* Connected to my-bucket.obs.eayun.com (182.150.27.112) port 9090 (#0)
#> PUT /test?partNumber=2&uploadId=2/lOQEuBY1nMjVA5pa15sPtOHMRwEk__a HTTP/1.1
#> Host: my-bucket.$OBSHOST
#> User-Agent: curl/7.43.0
#> Accept: */*
#> Authorization: AWS G7HGAZI01NOYBNWQ4EJD:t+amWGwhqWG6FvKNDtzJbis/gwM=
#> Date: Mon, 22 Feb 2016 09:48:51 +0000
#> Content-Type: application/octet-stream
#> Content-Length: 0
#>
#< HTTP/1.1 200
#< Date: Mon, 22 Feb 2016 09:48:51 GMT
#< Server: Apache/2.4.6 (CentOS) OpenSSL/1.0.1e-fips
#< Accept-Ranges: bytes
#< ETag: "d41d8cd98f00b204e9800998ecf8427e"
#< Content-Length: 0
#< Connection: close
#< Content-Type: application/xml
#< Set-Cookie: RADOSGWLB=ceph1; path=/
#< Cache-control: private
#<
#* Closing connection 0