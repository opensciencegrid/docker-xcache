FROM opensciencegrid/xcache:23-development

LABEL maintainer OSG Software <help@opensciencegrid.org>

# Specify the base Yum repository to get the necessary RPMs
ARG BASE_YUM_REPO=development
ARG BASE_OSG_SERIES=23
ARG BASE_OS=el9

ENV XC_IMAGE_NAME atlas-xcache

RUN yum install -y atlas-xcache --enablerepo="osg-$BASE_YUM_REPO" --enablerepo=osg-contrib && \
    yum install -y python3 python3-psutil python3-requests && \
    yum clean all --enablerepo=* && rm -rf /var/cache/

RUN yum install -y xrdcl-http


COPY gStream2tcp.py stats.py heartbeat.sh dark-data-cleaner.py /usr/local/sbin/
COPY runme.sh run_cache_reporter.sh run_x509_updater.sh /usr/local/sbin/

COPY config.d/* /etc/xrootd/config.d/
RUN chmod -x /etc/xrootd/config.d/*

RUN rm /etc/xrootd/config.d/50-osg-monitoring.cfg /etc/xrootd/config.d/50-osg-http.cfg

COPY 10-atlas-xcache-limits.conf /etc/security/limits.d
COPY supervisord.d/10-atlas-xcache.conf /etc/supervisord.d/
COPY image-config.d/10-atlas-xcache.sh /etc/osg/image-config.d/


RUN echo "g /atlas / rl" > /etc/xrootd/auth_db
RUN touch /var/run/x509up

# not sure this line is needed
RUN mkdir -p /xrd/var/log /xrd/var/spool /xrd/var/run /tests

# not sure the two lines bellow are needed at all
# if needed change ownership of directories
RUN if [ $(stat -c "%U:%G" /xrd/var ) != "xrootd:xrootd" ]; then chown -R xrootd:xrootd /xrd/var; fi
RUN if [ $(stat -c "%U:%G" /xrd ) != "xrootd:xrootd" ]; then chown -R xrootd:xrootd /xrd; fi

CMD [ "/usr/local/sbin/runme.sh" ]
