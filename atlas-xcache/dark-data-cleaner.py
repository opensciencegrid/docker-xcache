import os
from glob import glob
import time
from datetime import datetime
from multiprocessing import Process, Queue


def deleter_proc(queue):
    # Read from the queue; this will be spawned as a separate Process
    while True:
        filepath = queue.get()
        if filepath == 'DONE':
            break
        try:
            os.unlink(filepath)
        except OSError as oerr:
            print('could not delete file.', oerr)


BASE_DIR = '/xcache/meta/namespace'

DATA_DIRS = []
for i in range(1, 1000):
    if 'DISK_'+str(i) in os.environ:
        DATA_DIRS.append(os.environ['DISK_'+str(i)])
    else:
        break

print('DATA_DIRS:', DATA_DIRS)

Qu = Queue()

print('finding all the metadata links...')
files = [y for x in os.walk(BASE_DIR)
         for y in glob(os.path.join(x[0], '*'))]

print("removing all bad links...")
bad_links = 0
good_links = 0
for filename in files:
    if os.path.isdir(filename):
        continue
    try:
        last_modification_time = os.stat(filename).st_mtime
        good_links += 1
        # print(filename, last_modification_time)
    except OSError as oerr:
        if oerr.errno == 2:
            print('bad link?', oerr.filename)
            bad_links += 1
            os.unlink(filename)
        else:
            print('ERROR:', oerr)

print(datetime.now(), 'good links: {}, bad links:{}'.format(good_links, bad_links))

print("walking directory tree and deleting all empty directories...")
for i in range(3):
    dirs_deleted = 0
    dt = os.walk(BASE_DIR)
    for d in dt:
        if not d[1] and not d[2]:
            os.rmdir(d[0])
            dirs_deleted += 1
    print('deleted {} empty directories'.format(dirs_deleted))


print("finding all the files pointed by the links...")

links = [y for x in os.walk(BASE_DIR)
         for y in glob(os.path.join(x[0], '*'))]

real_paths = {}
for link in links:
    if os.path.isdir(link):
        continue
    real_paths[os.path.realpath(link)] = link


print("finding all data files, deleting ones not having metadata link...")

processes = []
workers = 16
pqueue = Queue()
for i in range(workers):
    deleter_p = Process(target=deleter_proc, args=((pqueue),))
    # deleter_p.daemon = True
    deleter_p.name = 'worker_' + str(i)
    processes.append(deleter_p)
    deleter_p.start()

toDelete = []
for disk in DATA_DIRS:
    all_files = 0
    deleted_data_files = 0
    files = [y for x in os.walk(disk+'/data')
             for y in glob(os.path.join(x[0], '*'))]
    for file in files:
        if os.path.isdir(file):
            continue
        all_files += 1
        if file not in real_paths:
            deleted_data_files += 1
            pqueue.put(file)
    print('disk:', disk, 'files:', all_files, 'deleted:', deleted_data_files)

for i in range(workers):
    pqueue.put('DONE')

print('Cleaning done.')
