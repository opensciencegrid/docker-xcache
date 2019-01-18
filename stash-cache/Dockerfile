FROM opensciencegrid/xcache

RUN yum -y install stash-cache --enablerepo=osg-minefield && \
    yum clean all --enablerepo=* && rm -rf /var/cache/

ADD cron.d/* /etc/cron.d/
ADD supervisord.d/* /etc/supervisord.d/
