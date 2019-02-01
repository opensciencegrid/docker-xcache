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

# Avoid 'Unable to create home directory' messages
# in the XRootD logs
WORKDIR /var/spool/xrootd

# Allow users to set the XRootD rootdir and sitename via env var
RUN echo -e "set rootdir = \$XC_ROOTDIR\nset sitename = \$XC_SITENAME\n" >> \
    /etc/xrootd/config.d/10-common-site-local.cfg

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
