FROM centos:centos7

RUN yum -y install http://repo.opensciencegrid.org/osg/3.4/osg-3.4-el7-release-latest.rpm && \
    yum -y install epel-release \
                   yum-plugin-priorities && \
    yum -y install stashcache-daemon fetch-crl stashcache-cache-server xrootd-lcmaps globus-proxy-utils

COPY  stashcache-server.cfg /etc/xrootd/xrootd-stashcache-cache-server.cfg

#EXPOSE 1094

RUN mkdir -p /data1/stash
RUN chown -R xrootd:xrootd /data1

USER xrootd
CMD ["xrootd", "-c", "/etc/xrootd/xrootd-stashcache-cache-server.cfg", "-k", "fifo", "-n", "stashcache-cache-server"]
