#!/usr/bin/env python3.6

import os
import sys
from glob import glob
import struct
import time
import requests
from datetime import datetime

BASE_DIR = '/xcache/meta/namespace'

ct = time.time()
start_time = ct - 3600
end_time = ct

if 'XC_RESOURCENAME' not in os.environ:
    print("xcache reporter - Must set $XC_RESOURCENAME. Exiting.")
    sys.exit(1)
if 'XC_REPORT_COLLECTOR' not in os.environ:
    print("xcache reporter - Must set $XC_REPORT_COLLECTOR. Exiting.")
    sys.exit(1)

site = os.environ['XC_RESOURCENAME']
collector = os.environ['XC_REPORT_COLLECTOR']

reports = []


def countSetBits(n):
    count = 0
    while n:
        count += n & 1
        n >>= 1
    return count


def get_info(filename):

    fin = open(filename, "rb")

    fv, = struct.unpack('i', fin.read(4))
    # print("file version:", fv)
    if fv < 4:
        return
    bs, = struct.unpack('q', fin.read(8))
    # print('bucket size:', bs)
    fs, = struct.unpack('q', fin.read(8))
    # print('file size:', fs)

    buckets = int((fs - 1) / bs + 1)
    # print('buckets:', buckets)

    time_of_creation, = struct.unpack('Q', fin.read(8))
    # print('time of creation:', datetime.fromtimestamp(time_of_creation))

    time_noCkSum, = struct.unpack('Q', fin.read(8))
    # print('time when first non-cksummed block was detected:',
    #       datetime.fromtimestamp(time_noCkSum))

    accesses, = struct.unpack('Q', fin.read(8))
    # print('accesses:', accesses)

    status, = struct.unpack('I', fin.read(4))
    # print('status:', status)

    accesses_stored, = struct.unpack('i', fin.read(4))
    # print('accesses stored:', accesses_stored)

    chksum_core, = struct.unpack('I', fin.read(4))
    # print('chksum core:', chksum_core)

    StateVectorLengthInBytes = int((buckets - 1) / 8 + 1)
    sv = struct.unpack(str(StateVectorLengthInBytes) + 'B',
                       fin.read(StateVectorLengthInBytes))  # disk written state vector
    # print('disk written state vector:\n ->', sv, '<-')

    inCache = 0
    for i in sv:
        inCache += countSetBits(i)
    # print('blocks cached:', inCache)

    rec = {
        'sender': 'xCache',
        'type': 'docs',
        'site': site,
        'file': filename.replace(BASE_DIR, '').replace('/atlas/rucio/', '').replace('.cinfo', ''),
        'size': fs,
        'created_at': time_of_creation * 1000,
        'blocks': buckets,
        'blocks_cached': inCache
    }

    for a in range(0, accesses_stored):
        attach_time, = struct.unpack('Q', fin.read(8))
        detach_time, = struct.unpack('Q', fin.read(8))
        ios, = struct.unpack('i', fin.read(4))
        dur, = struct.unpack('i', fin.read(4))
        nmrg, = struct.unpack('i', fin.read(4))
        reserved_for_future_use, = struct.unpack('i', fin.read(4))
        bhit, = struct.unpack('q', fin.read(8))
        bmis, = struct.unpack('q', fin.read(8))
        bype, = struct.unpack('q', fin.read(8))
        # print(
        #     'access:', a,
        #     'attached at:', datetime.fromtimestamp(attach_time),
        #     'detached at:', datetime.fromtimestamp(detach_time),
        #     'ios', ios,
        #     'duration', dur,
        #     'n merged', nmrg,
        #     'reserved for future_use', reserved_for_future_use,
        #     'bytes hit:', bhit,
        #     'bytes miss:', bmis,
        #     'bytes bypassed:', bype
        # )
        if detach_time > start_time and detach_time < end_time:
            dp = rec.copy()
            dp['access'] = a
            dp['attached_at'] = attach_time * 1000
            dp['detached_at'] = detach_time * 1000
            dp['ios'] = ios
            dp['duration'] = dur
            dp['merged'] = nmrg
            dp['bytes_hit'] = bhit
            dp['bytes_miss'] = bmis
            dp['bytes_bypassed'] = bype
            # dp['reserved_for_future_use'] = reserved_for_future_use
            reports.append(dp)

    # chksum, = struct.unpack('16s', fin.read(16))
    # print ('chksum:', chksum)


files = [y for x in os.walk(BASE_DIR)
         for y in glob(os.path.join(x[0], '*.cinfo'))]
# files += [y for x in os.walk(BASE_DIR) for y in glob(os.path.join(x[0], '*%'))]
for filename in files:
    try:
        last_modification_time = os.stat(filename).st_mtime
        # print(filename, last_modification_time)
        if last_modification_time > start_time and last_modification_time < end_time:
            get_info(filename)
    except OSError as oerr:
        if oerr.errno == 2:
            print('bad link?', oerr)
            # os.unlink(filename) # read only...
        else:
            print('ERROR:', oerr)

print("xcache reporter - files touched:", len(reports))
if len(reports) > 0:
    while len(reports):
        toSend = reports[0:100]
        r = requests.post(collector, json=toSend)
        print('xcache reporter - indexing response:', r.status_code)
        reports = reports[100:]
else:
    print("xcache reporter - Nothing to report")
