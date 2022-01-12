#!/usr/bin/env python3.6

# this code runs in a reporter container listens for gStream monitoring packets
# decodes them, resends as TCP packets

import os
import sys
import json
from json.decoder import JSONDecodeError
import socket

env = os.environ
if not('XC_MONITOR' in env):
    print('ERROR - needs environment variables XC_MONITOR')
    sys.exit(1)

UDP_SRC_IP = "127.0.0.1"
UDP_SRC_PORT = 9000

[TCP_DEST, TCP_DEST_PORT] = os.environ['XC_MONITOR'].split(':')
TCP_DEST_PORT = int(TCP_DEST_PORT)
print('sending to:', TCP_DEST, TCP_DEST_PORT)

try:
    udp_sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    udp_sock.bind((UDP_SRC_IP, UDP_SRC_PORT))
except OSError as e:
    print(e.errno, e.strerror)
    sys.exit(1)


def dispatch(data):
    try:
        tcp_sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        tcp_sock.connect((TCP_DEST, TCP_DEST_PORT))
        tcp_sock.sendall(bytes(data, encoding="utf-8"))
        tcp_sock.close()
    except OSError as e:
        print(e.errno, e.strerror)


count = 0
while True:
    parsed = {}
    data, addr = udp_sock.recvfrom(8192)
    try:
        data = data.decode("utf-8")
    except UnicodeDecodeError as e:
        print("Error decoding package:", e)
        continue

    # print("received message: %s" % data)

    hdr = data.split('\n')[0]
    try:
        h = json.loads(hdr)
    except JSONDecodeError as e:
        print("Error decoding header JSON:", e)
        continue
    except TypeError as e:
        print("Type error decoding JSON:", e)
        print("hdr:", hdr)
        continue
    parsed['pseq'] = h['pseq']
    parsed['site'] = h['src']['site']
    parsed['host'] = h['src']['host']

    payload = data[len(hdr)+1:-1]
    accs = payload.split('\n')
    docs = ''
    for a in accs:
        try:
            a = json.loads(a)
        except JSONDecodeError:
            print("doc issue", a)
            continue
        doc = parsed.copy()
        doc['lfn'] = a['lfn']
        doc['size'] = a['size']
        doc['blk_size'] = a['blk_size']
        doc['n_blks'] = a['n_blks']
        doc['n_blks_done'] = a['n_blks_done']
        doc['n_cks_errs'] = a['n_cks_errs']
        doc['access_cnt'] = a['access_cnt']
        doc['attach_t'] = a['attach_t']
        doc['detach_t'] = a['detach_t']
        doc['b_hit'] = a['b_hit']
        doc['b_miss'] = a['b_miss']
        doc['b_bypass'] = a['b_bypass']
        if a['remotes']:
            doc['remotes'] = a['remotes'][0]

        docs += json.dumps(doc)+'\n'
        count += 1
        if not count % 1000:
            print('resent:', count)
    dispatch(docs)
