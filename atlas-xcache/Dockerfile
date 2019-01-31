FROM opensciencegrid/xcache:development

LABEL maintainer OSG Software <help@opensciencegrid.org>

RUN yum install -y vo-client xrootd xrootd-client --enablerepo=osg-minefield && \
    yum install -y xrootd-rucioN2N-for-Xcache --enablerepo=osg-contrib && \
    yum clean all --enablerepo=* && rm -rf /var/cache/

COPY 10-atlas-xcache-limits.conf /etc/security/limits.d
COPY xrootd/xrootd-atlas-xcache.cfg /etc/xrootd/
COPY xrootd/config.d/* /etc/xrootd/config.d/
COPY supervisord.d/10-atlas-xcache.conf /etc/supervisord.d/
COPY atlas-xcache-init.sh /usr/local/sbin/
