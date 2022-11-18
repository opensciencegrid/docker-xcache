# ATLAS XCache Docker Image [![Build ATLAS xcache image](https://github.com/ivukotic/docker-xcache/actions/workflows/main.yml/badge.svg)](https://github.com/ivukotic/docker-xcache/actions/workflows/main.yml)

XCache provides a caching service for data federations that serve one or more Virtual Organizations (VOs) based on the
[XRootD](http://xrootd.org/) software.
This image, based on the [OSG XCache image](https://hub.docker.com/r/opensciencegrid/xcache), implements XCache for the
[ATLAS](http://atlas.cern/) data federation.

This document covers how to configure and start an ATLAS XCache container.

## Preparation

Install [CentOS-stream-9](https://www.centos.org/centos-stream/) on your node(s).

Separately mount all the disks that should be used for caching (JBODs). Have a list of mount directories and total disk size ready.

In addition to running XCache service itself, we require ATLAS instances to run two more processes:

- sending heartbeats to VP/Rucio
- forwarding monitoring information to ELK stack at UChicago.

This is easiest done using docker and docker-compose.

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

Copy the certificate cert and key pem files that will be used by the service to eg. /etc/grid-cert/ (<PATH TO CERT>).

Download [template configuration file](https://raw.githubusercontent.com/ivukotic/docker-xcache/master/atlas-xcache/docker-compose.yaml).

Edit everything that is surounded  with __< >__.

Start it:

```shell
docker-compose up -d
```

## Running ATLAS XCache
