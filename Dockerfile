##########
# xcache #
##########

# Specify the base Yum repository to get the necessary RPMs
ARG BASE_YUM_REPO=testing

FROM opensciencegrid/software-base:$BASE_YUM_REPO
LABEL maintainer OSG Software <help@opensciencegrid.org>

# Previous arg has gone out of scope
ARG BASE_YUM_REPO=testing

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
ADD xcache/packaging/* /var/lib/xcache/

# Install any pre-built RPMs
RUN yum -y install /var/lib/xcache/*.rpm --enablerepo="$BASE_YUM_REPO" || \
    true

RUN if [[ $BASE_YUM_REPO = release ]]; then \
       yumrepo=osg-upcoming; else \
       yumrepo=osg-upcoming-$BASE_YUM_REPO; fi && \
    yum install -y --enablerepo=$yumrepo \
        xcache \
        gperftools-devel && \
    yum clean all --enablerepo=* && rm -rf /var/cache/yum/

ADD xcache/cron.d/* /etc/cron.d/
RUN chmod 0644 /etc/cron.d/*
ADD xcache/sbin/* /usr/local/sbin/
ADD xcache/image-config.d/* /etc/osg/image-config.d/
ADD xcache/xrootd/* /etc/xrootd/config.d/

RUN mkdir -p "$XC_ROOTDIR"
RUN chown -R xrootd:xrootd /xcache/

# Avoid 'Unable to create home directory' messages
# in the XRootD logs
WORKDIR /var/spool/xrootd

################
# atlas-xcache #
################

FROM xcache AS atlas-xcache
LABEL maintainer OSG Software <help@opensciencegrid.org>

# Specify the base Yum repository to get the necessary RPMs
ARG BASE_YUM_REPO=testing

ENV XC_IMAGE_NAME atlas-xcache

RUN if [[ $BASE_YUM_REPO = release ]]; then \
       yumrepo=osg-upcoming; else \
       yumrepo=osg-upcoming-$BASE_YUM_REPO; fi && \
    yum install -y --enablerepo=$yumrepo --enablerepo=osg-contrib \
        atlas-xcache && \
    yum install -y python3 python3-psutil python3-requests && \
    yum clean all --enablerepo=* && rm -rf /var/cache/

COPY atlas-xcache/update-agis-status.sh /usr/local/sbin/
COPY atlas-xcache/update-cric-status.sh /usr/local/sbin/
COPY atlas-xcache/reporter.py stats.py /usr/local/sbin/
COPY atlas-xcache/10-atlas-xcache-limits.conf /etc/security/limits.d
COPY atlas-xcache/supervisord.d/10-atlas-xcache.conf /etc/supervisord.d/
COPY atlas-xcache/image-config.d/10-atlas-xcache.sh /etc/osg/image-config.d/

######################
# atlas-xcache-debug #
######################

FROM atlas-xcache AS atlas-xcache-debug
# Install debugging tools
RUN yum -y install -y --enablerepo="$BASE_YUM_REPO" \
    gdb \
    strace

