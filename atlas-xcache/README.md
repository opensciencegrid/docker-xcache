# ATLAS XCache Docker Image [![Build ATLAS xcache image](https://github.com/ivukotic/docker-xcache/actions/workflows/main.yml/badge.svg)](https://github.com/ivukotic/docker-xcache/actions/workflows/main.yml)

XCache provides a caching service for data federations that serve one or more Virtual Organizations (VOs) based on the
[XRootD](http://xrootd.org/) software.
This image, based on the [OSG XCache image](https://hub.docker.com/r/opensciencegrid/xcache), implements XCache for the
[ATLAS](http://atlas.cern/) data federation.

This document covers how to configure and start an ATLAS XCache container.

## Preparation

Install [CentOS-stream-9](https://www.centos.org/centos-stream/) on your node(s).

Separately mount all the disks that should be used for caching (JBODs). Have a list of mount directories and total disk size ready.

Install and start __docker__:

```shell
sudo yum remove -y docker docker-client docker-client-latest \
                  docker-common docker-latest docker-latest-logrotate \
                  docker-logrotate docker-engine

sudo yum install -y yum-utils

sudo yum-config-manager --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

sudo yum install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

sudo systemctl start docker
```

Install __docker-compose__:

```shell
curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose
```

## Configuration

Before starting the container, write a file containing the following required environment variables and values for your
XCache:

- `XC_RESOURCENAME`: The server name used for monitoring and reporting
- `XC_SPACE_HIGH_WM`: High watermark for disk usage;
  when usage goes above the high watermark, the cache deletes until it hits the low watermark
- `XC_SPACE_LOW_WM`: Low watermark for disk usage;
  when usage goes above the high watermark, the cache deletes until it hits the low watermark
- `XC_PORT`: TCP port that XCache listens on
- `XC_RAMSIZE`: Amount of memory to use for blocks in flight
- `XC_BLOCKSIZE`: The size of the blocks in the cache
- `XC_PREFETCH`: Number of blocks to prefetch from a file at once

Running ATLAS XCache
-------------------

In addition to running XCache service itself, we require ATLAS instances to run two more processes:

- sending heartbeats to VP/Rucio
- forwarding monitoring information to ELK stack at UChicago.

Get the
Update values in docker-compose.yaml file.

Start it:

```shell
docker-compose up -d
```

To run the container, use `docker run` with the following options, replacing the text within angle brackets with your
own values:

```shell
$ docker run --env-file=<PATH TO ENV FILE> \
             --volume <PATH TO HOST CERT>:/etc/grid-security/hostcert.pem \
             --volume <PATH TO HOST KEY>:/etc/grid-security/hostkey.pem \
             --volume <HOST PATH TO CACHE DISK 1>:<CONTAINER MOUNT POINT 1> \
             ...
             --volume <HOST PATH TO CACHE DISK N>:<CONTAINER MOUNT POINT N> \
             --publish <HOST PORT>:<XC_PORT> \
             --hostname <XCACHE HOSTNAME> \
             opensciencegrid/atlas-xcache:development
```
