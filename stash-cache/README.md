Stash Cache Docker Image [![Build Status](https://travis-ci.org/opensciencegrid/docker-xcache.svg?branch=master)](https://travis-ci.org/opensciencegrid/docker-xcache)
========================

The OSG operates the [StashCache data federation](https://opensciencegrid.org/docs/data/stashcache/overview/), which
provides organizations with a method to distribute their data in a scalable manner to thousands of jobs without needing
to pre-stage data across sites or operate their own scalable infrastructure.

[Stash Caches](https://opensciencegrid.org/docs/data/stashcache/install-cache/) transfer data to clients such as jobs or
users.
A set of caches are operated across the OSG for the benefit of nearby sites;
in addition, each site may run its own cache in order to reduce the amount of data transferred over the WAN.

This document describes how to configure, start, and verify a **Minimal** Stash Cache container.  There are no requirements to start a **Minimal** Stash Cache container.  Please follow [these instructions](https://opensciencegrid.org/docs/data/stashcache/install-cache/) to create a production Stash Cache server.

Running a Container
-------------------

To run the container, use `docker run` with the following options, replacing the text within angle brackets with your
own values:


```
$ docker run --rm --publish <HOST PORT>:8000 \
             opensciencegrid/stash-cache:fresh
```

The `HOST PORT` is the port on your computer which will accept caching requests.  You may see some failures.  


You can verify that it worked with the command:

```
$ curl http://localhost:8212/user/dweitzel/public/blast/queries/query1
```

Which should output:

```
>Derek's first query!
MPVSDSGFDNSSKTMKDDTIPTEDYEEITKESEMGDATKITSKIDANVIEKKDTDSENNITIAQDDEKVSWLQRVVEFFE
```

Readying for Production
------------------------

Additional configuration is needed to make StashCache production-ready.

1. Add a persistant caching directory from the docker host.  Add the volume argument to the run command.
2. Add environment variables to set the name of the cache and the directory of the persistant cache.  It is important to remember that the directory set in the environment variable points to the directory **inside** the container.  It is later mapped to a host directory with the `--volume` option.

An example final `docker run` command:
```
$ docker run --rm --publish <HOST PORT>:8000 \
             --volume /srv/cache:/cache
             --env-file=/opt/xcache/.env
             opensciencegrid/stash-cache:fresh
```

Where the environment file on the docker host, `/opt/xcache/.env`, has the following contents:
```
XC_RESOURCENAME=ProductionCache
XC_ROOTDIR=/cache
```

It is recommended to use a container orchestration service such as [docker-compose](https://docs.docker.com/compose/) or [kubernetes](https://kubernetes.io/), or start the XCache container with systemd.

An example systemd service file for xcache.  This will require creating the environment file in the directory `/opt/xcache/.env`.  

```
[Unit]
Description=XCache Container
After=docker.service
Requires=docker.service

[Service]
TimeoutStartSec=0
Restart=always
ExecStartPre=-/usr/bin/docker stop %n
ExecStartPre=-/usr/bin/docker rm %n
ExecStartPre=/usr/bin/docker pull opensciencegrid/stash-cache:fresh
ExecStart=/usr/bin/docker run --rm --name %n --publish 8000:8000 --volume /srv/cache:/cache --env-file /opt/xcache/.env opensciencegrid/stash-cache:fresh

[Install]
WantedBy=multi-user.target
```

This systemd file can be saved to `/etc/systemd/system/docker.stash-cache.service` and started with:

```
$ systemctl enable docker.stash-cache
$ systemctl start docker.stash-cache
```

Optional Configuration
----------------------

In addition to the configuration avove before starting the container, write the following configuration on your docker host:

1. Write in same file as above(`/opt/xcache/.env`) containing the following required environment  variables and values for your XCache:

    - `XC_SPACE_HIGH_WM`: High watermark for disk usage;
      when usage goes above the high watermark, the cache deletes until it hits the low watermark
    - `XC_SPACE_LOW_WM`: Low watermark for disk usage;
      when usage goes above the high watermark, the cache deletes until it hits the low watermark
    - `XC_PORT`: TCP port that XCache listens on
    - `XC_RAMSIZE`: Amount of memory to use for blocks in flight
    - `XC_BLOCKSIZE`: The size of the blocks in the cache
    - `XC_PREFETCH`: Number of blocks to prefetch from a file at once

### Disabling OSG monitoring (optional) ###

By default, XCache reports to the OSG so that OSG staff can monitor the health of data federations.
If you would like to report monitoring information to another destination, you can disable the OSG monitoring by setting
the following in your environment variable configuration:

```
DISABLE_OSG_MONITORING = true
```

