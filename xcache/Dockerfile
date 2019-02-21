FROM centos:centos7

LABEL maintainer OSG Software <help@opensciencegrid.org>

# Default root dir
ENV ROOTDIR /mnt/stash

# Create the xrootd user with a fixed GID/UID
RUN groupadd -o -g 10940 xrootd
RUN useradd -o -u 10940 -g 10940 -s /bin/sh xrootd

RUN yum -y install http://repo.opensciencegrid.org/osg/3.4/osg-3.4-el7-release-latest.rpm \
                   epel-release \
                   yum-plugin-priorities && \
    yum -y install xcache --enablerepo=osg-minefield && \
    yum -y install supervisor cronie vo-client && \
    yum clean all --enablerepo=* && rm -rf /var/cache/yum/

ADD cron.d/* /etc/cron.d/
ADD sbin/* /usr/local/sbin/
ADD supervisord.conf /etc/
ADD xrootd/10-docker-env-var.cfg /etc/xrootd/config.d/

# Avoid 'Unable to create home directory' messages
# in the XRootD logs
WORKDIR /var/spool/xrootd

CMD ["/usr/local/sbin/supervisord_startup.sh"]

