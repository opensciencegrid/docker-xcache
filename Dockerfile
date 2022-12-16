##########
# xcache #
##########

# Specify the base Yum repository to get the necessary RPMs
ARG BASE_YUM_REPO=testing
ARG BASE_OSG_SERIES=3.5

FROM opensciencegrid/software-base:$BASE_OSG_SERIES-el8-$BASE_YUM_REPO AS xcache
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
        gperftools-devel

ADD xcache/cron.d/* /etc/cron.d/
RUN chmod 0644 /etc/cron.d/*
ADD xcache/sbin/* /usr/local/sbin/
ADD xcache/image-config.d/* /etc/osg/image-init.d/
ADD xcache/xrootd/* /etc/xrootd/config.d/

RUN mkdir -p "$XC_ROOTDIR"
RUN chown -R xrootd:xrootd /xcache/

RUN rm -f /etc/xrootd/macaroon-secret

RUN yum install -y \
        cmake \
        gcc-c++ \
        libcurl-devel \
        openssl-devel \
        xrootd-server-devel \
        xrootd-server-libs && \
    yum clean all --enablerepo=* && rm -rf /var/cache/yum/

ADD xrootd-s3/ /xrootd-s3/
RUN cd /xrootd-s3 \
    && cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo \
             -DLIB_INSTALL_DIR:PATH=/usr/lib64 \
             -DCMAKE_INSTALL_PREFIX:PATH=/ \
             . \
    && make && make install  

# Avoid 'Unable to create home directory' messages
# in the XRootD logs
WORKDIR /var/spool/xrootd

################
# stash-origin #
################


FROM xcache AS stash-origin
LABEL maintainer OSG Software <help@opensciencegrid.org>

# Specify the base Yum repository to get the necessary RPMs
ARG BASE_YUM_REPO=testing

ENV XC_IMAGE_NAME stash-origin

# Do not stomp on host volume mount ownership
# Files and dirs should be readable to UID/GID 10940:10940 or the world
ENV XC_FIX_DIR_OWNERS no

RUN yum install -y stash-origin && \
    yum clean all --enablerepo=* && rm -rf /var/cache/yum/

COPY stash-origin/cron.d/* /etc/cron.d/
RUN chmod 0644 /etc/cron.d/*
COPY stash-origin/image-config.d/* /etc/osg/image-init.d/
COPY stash-origin/supervisord.d/* /etc/supervisord.d/

COPY stash-origin/xrootd/* /etc/xrootd/config.d/
# Add a placeholder scitokens.conf file, in case this origin isn't registered
# and can't pull down a new one
COPY stash-origin/scitokens.conf /run/stash-origin-auth/scitokens.conf
