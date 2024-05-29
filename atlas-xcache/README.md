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
sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose
```

## Configuration

Copy the certificate cert and key pem files that will be used by the service to eg. /etc/grid-cert/usercert.pem and /etc/grid-cert/userkey.pem

Make sure the files are owned by root and that the mode of the userkey.pem is 400.

Download [template configuration file](https://raw.githubusercontent.com/ivukotic/docker-xcache/master/atlas-xcache/docker-compose/docker-compose.yaml) and [.env](https://raw.githubusercontent.com/ivukotic/docker-xcache/master/atlas-xcache/docker-compose/.env) file.

Edit every line (except maybe port number and memory) in .env file.
For every disk you intend to use for xcache you should have one line in .env file that looks like this:

```
DISK_N=/home/cloud-user/diskN
```

and in docker-compose.yaml file you should have one line that looks like this:

```
      - &dN ${DISK_N}:/xcache/data_N
```

in reporter and heartbeats services of docker-compose.yaml, you should add corresponding volumes like this:

```
      - *dN
```

Start it:

```shell
sudo /usr/local/bin/docker-compose up -d
```

## Monitoring ATLAS XCache

Check that liveness signal is coming on this [dashboard](https://atlas-kibana.mwt2.org:5601/s/xcache/app/dashboards?auth_provider_hint=anonymous1#/view/46ff907f-c67d-5537-ae51-0598cbe2218f?_g=(filters%3A!()%2CrefreshInterval%3A(pause%3A!t%2Cvalue%3A300000)%2Ctime%3A(from%3Anow-24h%2Cto%3Anow))).

To monitor load, throughput etc. of the xcache node visit [this dashboard](https://atlas-kibana.mwt2.org:5601/s/xcache/app/dashboards?auth_provider_hint=anonymous1#/view/1c8f4388-7de1-54fb-879f-3d28edec4f99?_g=(filters%3A!()%2CrefreshInterval%3A(pause%3A!t%2Cvalue%3A300000)%2Ctime%3A(from%3Anow-24h%2Cto%3Anow))).

Details on ATLAS XCache usage can be found [here](https://atlas-kibana.mwt2.org:5601/s/xcache/app/dashboards?auth_provider_hint=anonymous1#/view/fa44eab6-9938-56dc-bc48-e877fd3092f2?_g=(filters%3A!()%2CrefreshInterval%3A(pause%3A!t%2Cvalue%3A300000)%2Ctime%3A(from%3Anow-24h%2Fh%2Cto%3Anow))).
 