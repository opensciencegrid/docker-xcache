#!/bin/bash

cp /s3-secrets/{access,private}_key /etc/xrootd/
chown xrootd: /etc/xrootd/{access,private}_key
