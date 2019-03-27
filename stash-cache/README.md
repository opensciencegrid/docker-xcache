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
             opensciencegrid/stash-cache:development
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

Optional Configuration
----------------------

Before starting the container, write the following configuration on your docker host:

1. Write a file containing the following required environment variables and values for your XCache:

    ```
    # The directory containing files to export from the cache
    XC_ROOTDIR=<dir>
    # The server name used for monitoring and reporting
    XC_RESOURCENAME
    ```

### Disabling OSG monitoring (optional) ###

By default, XCache reports to the OSG so that OSG staff can monitor the health of data federations.
If you would like to report monitoring information to another destination, you can disable the OSG monitoring by setting
the following in your environment variable configuration:

```
DISABLE_OSG_MONITORING = true
```

