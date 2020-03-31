FROM opensciencegrid/xcache:fresh

LABEL maintainer OSG Software <help@opensciencegrid.org>
RUN yum install -y cms-xcache --enablerepo=osg-testing && \
    yum clean all --enablerepo=* && rm -rf /var/cache/

RUN yum install -y  xcache-consistency-check --enablerepo=osg-testing

COPY limits.d/10-cms-xcache-limits.conf /etc/security/limits.d/
COPY supervisord.d/10-cms-xcache.conf /etc/supervisord.d/
COPY cron.d/* /etc/cron.d/
RUN chmod 0644 /etc/cron.d/*
COPY image-config.d/* /etc/osg/image-config.d/
COPY xcache-consistency-check-wrapper.sh /usr/bin/xcache-consistency-check-wrapper.sh

EXPOSE 1094
