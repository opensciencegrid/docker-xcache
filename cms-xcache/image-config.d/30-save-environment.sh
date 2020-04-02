#!/bin/bash
# This saves all the env vars passes to the ocntainer at launch in a way
# that other non-root processes can see them
cat /proc/1/environ | sed 's/\x00/\n/g' | grep "XC_"  >> /etc/environment
