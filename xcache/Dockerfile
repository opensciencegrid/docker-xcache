FROM opensciencegrid/software-base:fresh

LABEL maintainer OSG Software <help@opensciencegrid.org>

# Specify the base Yum repository to get the necessary RPMs
ARG BASE_YUM_REPO

# Default root dir
ENV XC_ROOTDIR /xcache/namespace

# Create the xrootd user with a fixed GID/UID
RUN groupadd -o -g 10940 xrootd
RUN useradd -o -u 10940 -g 10940 -s /bin/sh xrootd

RUN yum install -y --enablerepo="$BASE_YUM_REPO" \
        xcache \
        gperftools-devel && \
    yum clean all --enablerepo=* && rm -rf /var/cache/yum/

ADD cron.d/* /etc/cron.d/
RUN chmod 0644 /etc/cron.d/*
ADD sbin/* /usr/local/sbin/
ADD image-config.d/* /etc/osg/image-config.d/
ADD xrootd/* /etc/xrootd/config.d/

RUN mkdir -p "$XC_ROOTDIR"
RUN chown -R xrootd:xrootd /xcache/

# Avoid 'Unable to create home directory' messages
# in the XRootD logs
WORKDIR /var/spool/xrootd
