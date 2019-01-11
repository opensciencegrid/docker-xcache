FROM centos:centos7

ENV CACHEDIR /stash

RUN yum -y install http://repo.opensciencegrid.org/osg/3.4/osg-3.4-el7-release-latest.rpm \
                   epel-release \
                   yum-plugin-priorities && \
    yum -y install stash-cache --enablerepo=osg-minefield && \
    yum -y install supervisor cronie && \
    yum clean all --enablerepo=* && rm -rf /var/cache/yum/

ADD cron.d/* /etc/cron.d/
ADD sbin/* /usr/local/sbin/
ADD supervisor/supervisord.conf /etc/
ADD supervisor/supervisord.d/* /etc/supervisord.d

RUN mkdir $CACHEDIR && chown -R xrootd:xrootd $CACHEDIR

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"] 