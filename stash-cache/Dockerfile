###############
# stash-cache #
###############

FROM xcache:latest
LABEL maintainer OSG Software <help@opensciencegrid.org>

ARG BASE_YUM_REPO=testing

ENV XC_IMAGE_NAME stash-cache

RUN yum install -y stash-cache && \
    yum clean all --enablerepo=* && rm -rf /var/cache/

COPY cron.d/* /etc/cron.d/
RUN chmod 0644 /etc/cron.d/*
COPY supervisord.d/* /etc/supervisord.d/
COPY image-config.d/* /etc/osg/image-init.d/

# Add a placeholder authfile, incase this cache isn't registered
# and can't pull down a new one
COPY Authfile /run/stash-cache/Authfile
# Same for scitokens.conf
COPY scitokens.conf /run/stash-cache-auth/scitokens.conf

COPY rsyslog-stash-cache.conf /etc/rsyslog.d/stash-cache.conf

RUN mkdir -p /var/log/xrootd/stash-cache \
             /var/log/xrootd/stash-cache-auth && \
    touch    /var/log/xrootd/stash-cache/xrootd.log \
             /var/log/xrootd/stash-cache-auth/xrootd.log && \
    chown -R xrootd:xrootd /var/log/xrootd/stash-cache \
                           /var/log/xrootd/stash-cache-auth

EXPOSE 8000
