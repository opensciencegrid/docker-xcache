FROM opensciencegrid/xcache:fresh

RUN yum -y install stash-origin --enablerepo=osg-development && \
    yum clean all --enablerepo=* && rm -rf /var/cache/yum/

ADD cron.d/* /etc/cron.d/
ADD sbin/* /usr/local/sbin/
ADD supervisord.d/* /etc/supervisord.d/

ADD xrootd/* /etc/xrootd/config.d/

