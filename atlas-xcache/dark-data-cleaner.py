import os
from glob import glob
import time
from datetime import datetime

BASE_DIR = '/xcache/meta/namespace'

DATA_DIRS = []
for i in range(1, 1000):
    if 'DISK_'+str(i) in os.environ:
        DATA_DIRS.append(os.environ['DISK_'+str(i)])
    else:
        break

print('DATA_DIRS:', DATA_DIRS)

# walk directory tree and delete all empty directories
for i in range(3):
    dirs_deleted = 0
    dt = os.walk(BASE_DIR)
    for d in dt:
        if not d[1] and not d[2]:
            os.rmdir(d[0])
            dirs_deleted += 1
    print('deleted {} empty directories'.format(dirs_deleted))

# find all the links to actual files
files = [y for x in os.walk(BASE_DIR)
         for y in glob(os.path.join(x[0], '*'))]

# remove all bad links
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

# find all the files pointed by the links
links = [y for x in os.walk(BASE_DIR)
         for y in glob(os.path.join(x[0], '*'))]

real_paths = {}
for link in links:
    if os.path.isdir(link):
        continue
    real_paths[os.path.realpath(link)] = link

# find all data files, delete ones not having metadata link.

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
            os.unlink(file)
    print('disk:', disk, 'files:', all_files, 'deleted:', deleted_data_files)
