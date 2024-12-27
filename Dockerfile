##########
# xcache #
##########

# Specify the base Yum repository to get the necessary RPMs
ARG BASE_YUM_REPO=testing
ARG BASE_OSG_SERIES=23
ARG BASE_OS=el9

FROM opensciencegrid/software-base:$BASE_OSG_SERIES-$BASE_OS-$BASE_YUM_REPO AS xcache
LABEL maintainer="OSG Software <help@osg-htc.org>"

# Previous arg has gone out of scope
ARG BASE_YUM_REPO=testing

# Default root dir
ENV XC_ROOTDIR=/xcache/namespace

# Default logrotate XRootd logs
ENV XC_NUM_LOGROTATE=10

# Set namespace, data, and meta dir ownership to XRootD
ENV XC_FIX_DIR_OWNERS=yes

# Create the xrootd user with a fixed GID/UID
RUN groupadd -o -g 10940 xrootd
RUN useradd -o -u 10940 -g 10940 -s /bin/sh xrootd

# Create an empty macaroon-secret now so RPM installs won't create one, adding it to a layer.
RUN mkdir -p /etc/xrootd && touch /etc/xrootd/macaroon-secret

RUN mkdir -p /var/lib/xcache/
# ADD complains when there aren't files that match a wildcard so we
# this needs to be relatively unrestricted to support the case where
# there aren't any pre-built RPMs
ADD xcache/packaging/* /var/lib/xcache/

# Install any pre-built RPMs
RUN yum -y install /var/lib/xcache/*.rpm --enablerepo="osg-$BASE_YUM_REPO" || \
    true

RUN yum install -y \
        xcache \
        rsyslog \
        gperftools-devel && \
    yum clean all --enablerepo=* && rm -rf /var/cache/yum/

ADD xcache/cron.d/* /etc/cron.d/
RUN chmod 0644 /etc/cron.d/*
ADD xcache/sbin/* /usr/local/sbin/
ADD xcache/image-config.d/* /etc/osg/image-init.d/
ADD xcache/xrootd/* /etc/xrootd/config.d/
ADD xcache/rsyslog.conf /etc/rsyslog.conf

RUN rm -f /etc/rsyslog.d/listen.conf

RUN mkdir -p "$XC_ROOTDIR" /var/spool/rsyslog/workdir /var/run/rsyslog
RUN chown -R xrootd:xrootd /xcache/ /var/spool/rsyslog/workdir /var/run/rsyslog

COPY xcache/supervisord.d/* /etc/supervisord.d/

RUN rm -f /etc/xrootd/macaroon-secret

# Avoid 'Unable to create home directory' messages
# in the XRootD logs
WORKDIR /var/spool/xrootd

################
# atlas-xcache #
################

FROM xcache AS atlas-xcache
LABEL maintainer="OSG Software <help@osg-htc.org>"

# Specify the base Yum repository to get the necessary RPMs
ARG BASE_YUM_REPO=testing

ENV XC_IMAGE_NAME=atlas-xcache

RUN yum install -y --enablerepo=osg-contrib \
        --exclude=alja-\* \
        atlas-xcache && \
    yum install -y python3 python3-psutil python3-requests && \
    yum clean all --enablerepo=* && rm -rf /var/cache/

COPY atlas-xcache/sbin/* /usr/local/sbin/
COPY atlas-xcache/10-atlas-xcache-limits.conf /etc/security/limits.d
COPY atlas-xcache/supervisord.d/10-atlas-xcache.conf /etc/supervisord.d/
COPY atlas-xcache/image-config.d/10-atlas-xcache.sh /etc/osg/image-init.d/
COPY atlas-xcache/rsyslog-atlas-xcache.conf /etc/rsyslog.d/atlas-xcache.conf

RUN mkdir -p /var/log/xrootd/atlas-xcache && \
    touch    /var/log/xrootd/atlas-xcache/xrootd.log && \
    chown -R xrootd:xrootd /var/log/xrootd/atlas-xcache

##############
# cms-xcache #
##############

FROM xcache AS cms-xcache
LABEL maintainer="OSG Software <help@osg-htc.org>"

ARG BASE_YUM_REPO=testing

ENV XC_IMAGE_NAME=cms-xcache

RUN yum install -y \
                cms-xcache \
                xcache-consistency-check && \
    yum clean all --enablerepo=* && rm -rf /var/cache/

COPY cms-xcache/limits.d/10-cms-xcache-limits.conf /etc/security/limits.d/
COPY cms-xcache/supervisord.d/10-cms-xcache.conf /etc/supervisord.d/
COPY cms-xcache/cron.d/* /etc/cron.d/
RUN chmod 0644 /etc/cron.d/*
COPY cms-xcache/image-config.d/* /etc/osg/image-init.d/
COPY cms-xcache/xcache-consistency-check-wrapper.sh /usr/bin/xcache-consistency-check-wrapper.sh
COPY cms-xcache/rsyslog-cms-xcache.conf /etc/rsyslog.d/cms-xcache.conf

RUN mkdir -p /var/log/xrootd/cms-xcache && \
    touch    /var/log/xrootd/cms-xcache/xrootd.log && \
    chown -R xrootd:xrootd /var/log/xrootd/cms-xcache

EXPOSE 1094

###############
# stash-cache #
###############

FROM xcache AS stash-cache
LABEL maintainer="OSG Software <help@osg-htc.org>"

ARG BASE_YUM_REPO=testing

ENV XC_IMAGE_NAME=stash-cache

RUN yum install -y stash-cache && \
    yum clean all --enablerepo=* && rm -rf /var/cache/

COPY stash-cache/cron.d/* /etc/cron.d/
RUN chmod 0644 /etc/cron.d/*
COPY stash-cache/supervisord.d/* /etc/supervisord.d/
COPY stash-cache/image-config.d/* /etc/osg/image-init.d/

# Add a placeholder authfile, incase this cache isn't registered
# and can't pull down a new one
COPY stash-cache/Authfile /run/stash-cache/Authfile
# Same for scitokens.conf
COPY stash-cache/scitokens.conf /run/stash-cache-auth/scitokens.conf

COPY stash-cache/rsyslog-stash-cache.conf /etc/rsyslog.d/stash-cache.conf

RUN mkdir -p /var/log/xrootd/stash-cache \
             /var/log/xrootd/stash-cache-auth && \
    touch    /var/log/xrootd/stash-cache/xrootd.log \
             /var/log/xrootd/stash-cache-auth/xrootd.log && \
    chown -R xrootd:xrootd /var/log/xrootd/stash-cache \
                           /var/log/xrootd/stash-cache-auth

EXPOSE 8000

################
# stash-origin #
################


FROM xcache AS stash-origin
LABEL maintainer="OSG Software <help@osg-htc.org>"

# Specify the base Yum repository to get the necessary RPMs
ARG BASE_YUM_REPO=testing

ENV XC_IMAGE_NAME=stash-origin

# Do not stomp on host volume mount ownership
# Files and dirs should be readable to UID/GID 10940:10940 or the world
ENV XC_FIX_DIR_OWNERS=no

# Add support for SSSD (SOFTWARE-5464)
# sssd UID must match between the origin and SSSD sidecar containers
RUN groupadd -r -g 990 sssd \
    && useradd -r -g sssd -u 990 -d / -s /usr/sbin/nologin -c "System user for sssd" sssd

RUN yum install -y stash-origin \
                   xrootd-multiuser \
                   sssd && \
    yum clean all --enablerepo=* && rm -rf /var/cache/yum/

# HACK: we want folks to be able to opt into multiuser and this config
# will blow up non-multiuser setups (SOFTWARE-5478)
RUN rm /etc/xrootd/config.d/60-osg-multiuser.cfg

COPY stash-origin/cron.d/* /etc/cron.d/
RUN chmod 0644 /etc/cron.d/*
COPY stash-origin/image-config.d/* /etc/osg/image-init.d/
COPY stash-origin/supervisord.d/* /etc/supervisord.d/

COPY stash-origin/xrootd/* /etc/xrootd/config.d/
# Add a placeholder scitokens.conf file, in case this origin isn't registered
# and can't pull down a new one
COPY stash-origin/scitokens.conf /run/stash-origin-auth/scitokens.conf

COPY stash-origin/rsyslog-stash-origin.conf /etc/rsyslog.d/stash-origin.conf

RUN mkdir -p /var/log/xrootd/stash-origin \
             /var/log/xrootd/stash-origin-auth && \
    touch    /var/log/xrootd/stash-origin/xrootd.log \
             /var/log/xrootd/stash-origin/cmsd.log \
             /var/log/xrootd/stash-origin-auth/xrootd.log \
             /var/log/xrootd/stash-origin-auth/cmsd.log && \
    chown -R xrootd:xrootd /var/log/xrootd/stash-origin \
                           /var/log/xrootd/stash-origin-auth


######################
# atlas-xcache-debug #
######################

FROM atlas-xcache AS atlas-xcache-debug
# Install debugging tools
# Previous arg has gone out of scope
ARG BASE_YUM_REPO=testing
RUN yum -y install -y --enablerepo="osg-$BASE_YUM_REPO" \
    gdb \
    strace

####################
# cms-xcache-debug #
####################

FROM cms-xcache AS cms-xcache-debug
# Install debugging tools
# Previous arg has gone out of scope
ARG BASE_YUM_REPO=testing
RUN yum -y install -y --enablerepo="osg-$BASE_YUM_REPO" \
    gdb \
    strace

#####################
# stash-cache-debug #
#####################

FROM stash-cache AS stash-cache-debug
# Install debugging tools
# Previous arg has gone out of scope
ARG BASE_YUM_REPO=testing
RUN yum -y install -y --enablerepo="osg-$BASE_YUM_REPO" \
    gdb \
    strace

######################
# stash-origin-debug #
######################

FROM stash-origin AS stash-origin-debug
# Install debugging tools
# Previous arg has gone out of scope
ARG BASE_YUM_REPO=testing
RUN yum -y install -y --enablerepo="osg-$BASE_YUM_REPO" \
    gdb \
    strace
