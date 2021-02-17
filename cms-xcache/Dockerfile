ARG BASE_YUM_REPO=testing

FROM opensciencegrid/xcache:$BASE_YUM_REPO

LABEL maintainer OSG Software <help@opensciencegrid.org>

# Specify the base Yum repository to get the necessary RPMs
ARG BASE_YUM_REPO=testing

ENV XC_IMAGE_NAME cms-xcache

RUN if [[ $BASE_YUM_REPO = release ]]; then \
       yumrepo=osg-upcoming; else \
       yumrepo=osg-upcoming-$BASE_YUM_REPO; fi && \
     yum install -y --enablerepo=$yumrepo \
                cms-xcache \
                xcache-consistency-check && \
    yum clean all --enablerepo=* && rm -rf /var/cache/

COPY limits.d/10-cms-xcache-limits.conf /etc/security/limits.d/
COPY supervisord.d/10-cms-xcache.conf /etc/supervisord.d/
COPY cron.d/* /etc/cron.d/
RUN chmod 0644 /etc/cron.d/*
COPY image-config.d/* /etc/osg/image-config.d/
COPY xcache-consistency-check-wrapper.sh /usr/bin/xcache-consistency-check-wrapper.sh

EXPOSE 1094
