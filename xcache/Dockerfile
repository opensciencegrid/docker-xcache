FROM opensciencegrid/software-base:fresh

LABEL maintainer OSG Software <help@opensciencegrid.org>

# Default root dir
ENV ROOTDIR /mnt/stash

# Create the xrootd user with a fixed GID/UID
RUN groupadd -o -g 10940 xrootd
RUN useradd -o -u 10940 -g 10940 -s /bin/sh xrootd

RUN yum -y install xcache --enablerepo=osg-testing && \
    yum clean all --enablerepo=* && rm -rf /var/cache/yum/

ADD cron.d/* /etc/cron.d/
RUN chmod 0644 /etc/cron.d/*
ADD sbin/* /usr/local/sbin/
ADD image-config.d/* /etc/osg/image-config.d/
ADD xrootd/10-docker-env-var.cfg /etc/xrootd/config.d/

# Avoid 'Unable to create home directory' messages
# in the XRootD logs
WORKDIR /var/spool/xrootd
