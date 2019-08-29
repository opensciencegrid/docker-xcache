FROM opensciencegrid/xcache:fresh

RUN yum -y install stash-origin --enablerepo=osg-minefield && \
    yum clean all --enablerepo=* && rm -rf /var/cache/yum/

ADD cron.d/* /etc/cron.d/
RUN chmod 0644 /etc/cron.d/*
ADD image-config.d/* /etc/osg/image-config.d/
ADD supervisord.d/* /etc/supervisord.d/

ADD xrootd/* /etc/xrootd/config.d/

