##############
# cms-xcache #
##############

FROM xcache:latest
LABEL maintainer OSG Software <help@opensciencegrid.org>

ARG BASE_YUM_REPO=testing

ENV XC_IMAGE_NAME cms-xcache

RUN yum install -y \
                cms-xcache \
                xcache-consistency-check && \
    yum clean all --enablerepo=* && rm -rf /var/cache/

COPY limits.d/10-cms-xcache-limits.conf /etc/security/limits.d/
COPY supervisord.d/10-cms-xcache.conf /etc/supervisord.d/
COPY cron.d/* /etc/cron.d/
RUN chmod 0644 /etc/cron.d/*
COPY image-config.d/* /etc/osg/image-init.d/
COPY xcache-consistency-check-wrapper.sh /usr/bin/xcache-consistency-check-wrapper.sh
COPY rsyslog-cms-xcache.conf /etc/rsyslog.d/cms-xcache.conf

RUN mkdir -p /var/log/xrootd/cms-xcache && \
    touch    /var/log/xrootd/cms-xcache/xrootd.log && \
    chown -R xrootd:xrootd /var/log/xrootd/cms-xcache

EXPOSE 1094
