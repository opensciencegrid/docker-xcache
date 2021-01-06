FROM opensciencegrid/software-base:fresh

LABEL maintainer OSG Software <help@opensciencegrid.org>

# Specify the base Yum repository to get the necessary RPMs
# ARG BASE_YUM_REPO
ENV BASE_YUM_REPO osg-upcoming-development
ARG DEBUG

# Default root dir
ENV XC_ROOTDIR /xcache/namespace

# Default logrotate XRootd logs
ENV XC_NUM_LOGROTATE 10

# Set namespace, data, and meta dir ownership to XRootD
ENV XC_FIX_DIR_OWNERS yes

# Create the xrootd user with a fixed GID/UID
RUN groupadd -o -g 10940 xrootd
RUN useradd -o -u 10940 -g 10940 -s /bin/sh xrootd

RUN mkdir -p /var/lib/xcache/
# ADD complains when there aren't files that match a wildcard so we
# this needs to be relatively unrestricted to support the case where
# there aren't any pre-built RPMs
ADD packaging/* /var/lib/xcache/

# Install any pre-built RPMs
RUN yum -y install /var/lib/xcache/*.rpm --enablerepo="$BASE_YUM_REPO" || \
    true

# Install debugging tools if DEBUG set
RUN [[ -z "$DEBUG" ]] || \
    yum -y install -y --enablerepo="$BASE_YUM_REPO" \
    gdb \
    strace

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
