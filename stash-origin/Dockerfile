################
# stash-origin #
################


FROM xcache:latest
LABEL maintainer OSG Software <help@opensciencegrid.org>

# Specify the base Yum repository to get the necessary RPMs
ARG BASE_YUM_REPO=testing

ENV XC_IMAGE_NAME stash-origin

# Do not stomp on host volume mount ownership
# Files and dirs should be readable to UID/GID 10940:10940 or the world
ENV XC_FIX_DIR_OWNERS no

# Add support for SSSD (SOFTWARE-5464)
# sssd UID must match between the origin and SSSD sidecar containers
RUN groupadd -r -g 10996 sssd \
    && useradd -r -g sssd -u 10996 -d / -s /usr/sbin/nologin -c "System user for sssd" sssd

RUN yum install -y stash-origin \
                   xrootd-multiuser \
                   sssd && \
    yum clean all --enablerepo=* && rm -rf /var/cache/yum/

# HACK: we want folks to be able to opt into multiuser and this config
# will blow up non-multiuser setups (SOFTWARE-5478)
RUN rm /etc/xrootd/config.d/60-osg-multiuser.cfg

COPY cron.d/* /etc/cron.d/
RUN chmod 0644 /etc/cron.d/*
COPY image-config.d/* /etc/osg/image-init.d/
COPY supervisord.d/* /etc/supervisord.d/

COPY xrootd/* /etc/xrootd/config.d/
# Add a placeholder scitokens.conf file, in case this origin isn't registered
# and can't pull down a new one
COPY scitokens.conf /run/stash-origin-auth/scitokens.conf

COPY rsyslog-stash-origin.conf /etc/rsyslog.d/stash-origin.conf

RUN mkdir -p /var/log/xrootd/stash-origin \
             /var/log/xrootd/stash-origin-auth && \
    touch    /var/log/xrootd/stash-origin/xrootd.log \
             /var/log/xrootd/stash-origin/cmsd.log \
             /var/log/xrootd/stash-origin-auth/xrootd.log \
             /var/log/xrootd/stash-origin-auth/cmsd.log && \
    chown -R xrootd:xrootd /var/log/xrootd/stash-origin \
                           /var/log/xrootd/stash-origin-auth
