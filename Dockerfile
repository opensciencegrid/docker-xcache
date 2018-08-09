FROM centos:centos7

RUN yum -y install http://repo.opensciencegrid.org/osg/3.4/osg-3.4-el7-release-latest.rpm && \
    yum -y install epel-release \
                   yum-plugin-priorities && \
    yum -y install osg-ca-certificates && \
    yum -y install stashcache-daemon fetch-crl stashcache-cache-server lcmaps-plugins-scas-client xrootd-lcmaps globus-proxy-utils && \
    yum -y install supervisor

RUN mkdir -p /var/log/supervisor
ADD supervisord.conf /etc/supervisord.conf

#USER xrootd
#CMD ["xrootd", "-c", "/etc/xrootd/xrootd-stashcache-cache-server.cfg", "-k", "fifo", "-n", "stashcache-cache-server"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"] 