#!/bin/bash

# Remove the core file soft limit
[[ -z "$DEBUG" ]] || ulimit -S -c unlimited
