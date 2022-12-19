#!/bin/bash

cp /s3-keys/{access,private}_key /etc/xrootd/
chown xrootd: /etc/xrootd/{access_private}_key
