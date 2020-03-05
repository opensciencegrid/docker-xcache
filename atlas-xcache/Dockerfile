FROM opensciencegrid/xcache:fresh

LABEL maintainer OSG Software <help@opensciencegrid.org>

RUN yum install -y atlas-xcache --enablerepo=osg-testing --enablerepo=osg-contrib && \
    yum clean all --enablerepo=* && rm -rf /var/cache/

COPY update-agis-status.sh /usr/local/sbin/
COPY 10-atlas-xcache-limits.conf /etc/security/limits.d
COPY supervisord.d/10-atlas-xcache.conf /etc/supervisord.d/
COPY image-config.d/10-atlas-xcache.sh /etc/osg/image-config.d/
