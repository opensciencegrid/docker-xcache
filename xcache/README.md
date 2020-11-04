XCache Docker Image ![Build XCache images from OSG Yum repositories](https://github.com/opensciencegrid/docker-xcache/workflows/Build%20XCache%20images%20from%20OSG%20Yum%20repositories/badge.svg)
===================

XCache provides a caching service for data federations that serve one or more Virtual Organizations (VOs) based on the
[XRootD](http://xrootd.org/) software.
The XCache image contains services and configuration common to all XCache implementations in the OSG but is not intended
to be used as a standalone container.

This document covers the contents of the XCache image and how to use it as a base image.

Contents
--------

- An `xrootd` user with a UID and GID of 10940
- OSG and EPEL Yum repositories
- OSG CA certificates and VO configuration
- [xcache](https://github.com/opensciencegrid/xcache) RPM installation
- [Supervisor](supervisord.org/) to support multi-process containers
- Periodic `fetch-crl`
- Reporting to central OSG monitoring (see below for details)
- XRootD configuration `resourcename` via `XC_RESOURCENAME` environment variables
- Entrypoints for downstream Docker images and Kubernetes pods

Building Other Images
---------------------

The XCache base image is not intended to be used as a standalone container but rather as the base for other XCache
implementations.
To use the latest XCache image as the base for your docker image, add the following to the top of your `Dockerfile`:

```
FROM opensciencegrid/xcache:development
```

### Disabling OSG monitoring (optional) ###

By default, XCache reports to the OSG central collector and OSG storage monitor so that OSG staff can monitor the health
of data federations.
If you would like to report monitoring information to another destination, you can disable the OSG monitoring by setting
the following in your environment variable configuration:

```
DISABLE_OSG_MONITORING = true
```
