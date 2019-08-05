FROM opensciencegrid/xcache:fresh

LABEL maintainer OSG Software <help@opensciencegrid.org>

RUN yum install -y cms-xcache --enablerepo=osg-minefield && \
    yum clean all --enablerepo=* && rm -rf /var/cache/

COPY limits.d/10-cms-xcache-limits.conf /etc/security/limits.d/
COPY supervisord.d/10-cms-xcache.conf /etc/supervisord.d/
COPY sbin/* /usr/local/sbin/
COPY cron.d/* /etc/cron.d/