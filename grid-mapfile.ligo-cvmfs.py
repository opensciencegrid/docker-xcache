#!/usr/bin/env python

import os
import tempfile
import urllib
import zlib
import sqlite3

LIGO = 'http://cvmfs-s1goc.opensciencegrid.org/cvmfs/ligo.osgstorage.org'
#TARGET = '/opt/kickstart/configs/certificates/grid-mapfile.ligo'
TARGET = '/tmp/grid-mapfile.ligo'

def get_catalog_id(base_url):
    """Retrieve CVMFS catalog ID from the manifest"""
    manifest = urllib.urlopen(base_url + '/.cvmfspublished')

    for line in manifest:
        if line.startswith('C'):
            return line[1:].strip()

    raise ValueError('Catalog ID not found in manifest')

def download_db(base_url, catalog_id, fptr):
    """Retrieve file catalog database"""
    cat_url = base_url + '/data/' + catalog_id[0:2] + '/' + catalog_id[2:] + 'C'

    cat_gz = urllib.urlopen(cat_url)
    cat_db = zlib.decompress(cat_gz.read())

    fptr.write(cat_db)
    fptr.flush()

def main():
    # Retrieve catalog ID for repo
    cat_id = get_catalog_id(LIGO)

    # Retrieve file catalog database
    cat_db = tempfile.NamedTemporaryFile()
    download_db(LIGO, cat_id, cat_db)

    # Open file catalog database and query for voms_authz property
    con = sqlite3.connect(cat_db.name)
    cur = con.cursor()
    cur.execute("SELECT value FROM properties WHERE key='voms_authz'")
    voms_authz = cur.fetchone()[0]

    # Create a tempfile
    tmp = tempfile.NamedTemporaryFile(dir=os.path.dirname(TARGET))

    # Write header
    tmp.write('##############################################################################\n')
    tmp.write('# LIGO users for xrootd access\n')
    tmp.write('##############################################################################\n')

    # Loop over DNs
    for entry in voms_authz.splitlines():
        # Exclude any lines that don't start with '/'
        if not entry.startswith('/'):
            continue

        # Strip any double-quotes from the DN
        # (Shanna, they bought their tickets, they knew what they were getting into.)
        entry.replace('"', '')

        # Generate output line
        tmp.write('"%s" ligo\n' % (entry))

    # Write footer
    tmp.write('##############################################################################\n')
    tmp.write('# LIGO end\n')
    tmp.write('##############################################################################\n')

    # Set permissions
    os.fchmod(tmp.fileno(), 0644)

    # Flush and sync data
    tmp.flush()
    os.fsync(tmp.fileno())

    # Rename our tempfile into place and disable auto-delete
    os.rename(tmp.name, TARGET)
    tmp.delete = False

if __name__ == "__main__":
    main()
