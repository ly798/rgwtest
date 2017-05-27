import json
import logging
import requests

import eventlet
from awsauth import S3Auth

try:
    import xml.etree.cElementTree as ET
except ImportError:
    import xml.etree.ElementTree as ET

server = ''
aws_key = ''
secret = ''

auth = S3Auth(aws_key, secret, server)

logging.basicConfig(level=logging.INFO,
                    format='%(asctime)s %(filename)s[%(lineno)d] %(levelname)s: %(message)s',
                    datefmt='%Y-%m-%d %H:%M:%S',
                    filename='tempremove.log',
                    filemode='a')


def _get_user_keys(user):
    url = 'http://%s/admin/user?format=json&uid=%s' % (server, user)
    try:
        r = requests.get(url, auth=auth)
        user = json.loads(r.content)
        key_info = user.get('keys')[0]
        return key_info['access_key'], key_info['secret_key']
    except Exception as e:
        logging.error(e)


def _get_buckets(user):
    url = 'http://%s/admin/bucket?uid=%s&format=json' % (server, user)
    try:
        r = requests.get(url, auth=auth)
        return eval(r.content)
    except Exception as e:
        logging.error(e)


def get_users():
    url = 'http://%s/admin/metadata/user?format=json' % server
    try:
        r = requests.get(url, auth=auth)
        return eval(r.content)
    except Exception as e:
        logging.error(e)


def _get_task(user_auth, bucket):
    url = 'http://%s.%s/?uploads' % (bucket, server)
    try:
        r = requests.get(url, auth=user_auth)
        tree = ET.fromstring(r.content)
        if tree.find('Upload'):
            return [(elem.find('Key').text, elem.find('UploadId').text)
                    for elem in tree.iter('Upload')]
        else:
            return []
    except Exception as e:
        logging.error(e)


def _task_delete(access_key, secret_key, bucket):
    # print access_key, secret_key, bucket
    user_auth = S3Auth(access_key, secret_key, server)
    # print bucket
    task = _get_task(user_auth, bucket)
    if task:
        for key, upload_id in task:
            url = 'http://%s.%s/%s?uploadId=%s' % (bucket, server, key, upload_id)
            try:
                r = requests.delete(url, auth=user_auth)
            except Exception as e:
                logging.error(e)


def temp_remove(user, pool):
    buckets = _get_buckets(user)
    if buckets:
        access_key, secret_key = _get_user_keys(user)
        for bucket in buckets:
            _task_delete(access_key, secret_key, bucket)
            # print pool.running()
    else:
        logging.warning("The user %s has no buckets." % user)


def main():
    logging.info("============== Start ==============")
    pool = eventlet.GreenPool()
    for user in get_users():
        pool.spawn(temp_remove, user, pool)
    pool.waitall()
    logging.info("============== End ==============")


if __name__ == '__main__':
    main()
