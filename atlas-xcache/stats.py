#!/usr/bin/env python3.6

import os
import time
import shutil
import psutil
import requests


class Xdisks:
    def __init__(self):
        self.DISKS = []
        self.META = []
        self.last_update = None
        self.setup()
        self.update()

    def setup(self):
        for k in dict(os.environ):
            if k.startswith('DISK'):
                self.DISKS.append(Xdisk(os.environ[k]))
        self.META.append(Xdisk('/xcache/meta'))

    def update(self):
        file_path = '/proc/diskstats'
        # ref: http://lxr.osuosl.org/source/Documentation/iostats.txt
        columns_disk = ['m', 'mm', 'dev', 'reads', 'rd_mrg', 'rd_sectors',
                        'ms_reading', 'writes', 'wr_mrg', 'wr_sectors',
                        'ms_writing', 'cur_ios', 'ms_doing_io', 'ms_weighted']
        lines = open(file_path, 'r').readlines()
        self.last_update = time.time()
        for line in lines:
            if line == '':
                continue
            split = line.split()
            if len(split) != len(columns_disk):
                continue
            data = dict(zip(columns_disk, split))
            # change values to ints.
            for key in data:
                if key != 'dev':
                    data[key] = int(data[key])
            # get Xdisk with this data['dev'] device and set values
            for DISK in self.DISKS + self.META:
                if DISK.device == data['dev']:
                    if self.last_update and DISK.iostat_previous:
                        for k in data:
                            if k == 'dev':
                                continue
                            DISK.iostat[k] = data[k] - DISK.iostat_previous[k]
                        # this is not incremented
                        DISK.iostat['cur_ios'] = data['cur_ios']
                    DISK.iostat_previous = data
                    break

    def report(self):
        for DISK in self.DISKS + self.META:
            print(DISK)
        print('--------------------------------------')


class Xdisk:
    def __init__(self, path, lwm=0.95, hwm=0.98):
        self.path = path
        self.lwm = lwm
        self.hwm = hwm
        self.device = ''
        self.iostat_previous = {}
        self.iostat = {}
        self.set_device()

    def __str__(self):
        res = '{:20} device: {:10} used: {}% '.format(
            self.path, self.device, int(self.get_utilization() * 100))
        for k, v in self.iostat.items():
            res += k + ':' + str(v)+' '
        return res

    def get_space(self):
        return shutil.disk_usage(self.path)

    def get_utilization(self):
        (total, used, free) = shutil.disk_usage(self.path)
        return used / total

    def get_free_space(self):
        (total, used, free) = shutil.disk_usage(self.path)
        return free

    def set_device(self):
        file_path = '/etc/mtab'
        lines = open(file_path, 'r').readlines()
        for line in lines:
            if line == '':
                continue
            w = line.split(' ')
            if w[1] == self.path:
                self.device = w[0].replace('/dev/', '')
                break


class XNode:
    def __init__(self):
        self.net_io_prev = psutil.net_io_counters()

    def get_load(self):
        return os.getloadavg()  # 1, 5, 15 min

    def get_network(self):
        net_io = psutil.net_io_counters()
        res = {
            'sent': net_io.bytes_sent - self.net_io_prev.bytes_sent,
            'received': net_io.bytes_recv - self.net_io_prev.bytes_recv
        }
        self.net_io_prev = net_io
        return res


def report():
    if 'XC_RESOURCENAME' not in os.environ:
        print("xcache reporter - Must set $XC_RESOURCENAME. Exiting.")
        return
    if 'XC_REPORT_COLLECTOR' not in os.environ:
        print("xcache reporter - Must set $XC_REPORT_COLLECTOR. Exiting.")
        return

    site = os.environ['XC_RESOURCENAME']
    collector = os.environ['XC_REPORT_COLLECTOR']
    data = []
    header = {
        'sender': 'xCacheNode',
        'type': 'docs',
        'site': site,
        'timestamp': int(time.time() * 1000)
    }
    load_rec = header.copy()
    load_rec['load'] = no.get_load()[0]
    data.append(load_rec)
    netw_rec = header.copy()
    netw_rec['network'] = no.get_network()
    data.append(netw_rec)
    for DISK in xd.DISKS + xd.META:
        disk_rec = header.copy()
        disk_rec['device'] = DISK.device
        disk_rec['mount'] = DISK.path
        disk_rec['used'] = DISK.get_utilization()
        for k, v in DISK.iostat.items():
            disk_rec[k] = v
        data.append(disk_rec)
    try:
        res = requests.post(collector, json=data)
        print('stats reporter - indexing response:', res.status_code)
    except Exception as exc:
        print('collector issue?', exc)


if __name__ == "__main__":
    xd = Xdisks()
    no = XNode()
    while True:
        xd.update()
        # xd.report()
        report()
        time.sleep(60)
