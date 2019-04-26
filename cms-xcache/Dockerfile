FROM opensciencegrid/xcache:fresh

RUN yum -y install xrootd --enablerepo=osg-minefield
RUN yum -y install gperftools-libs

ADD xrootd/xcache.cfg /etc/xrootd/
ADD xrootd/xcache-cmsd.cfg /etc/xrootd/
ADD xrootd/config-common.d/* /etc/xrootd/config-common.d/
ADD xrootd/config-xrootd.d/* /etc/xrootd/config-xrootd.d/
ADD xrootd/config-cmsd.d/* /etc/xrootd/config-cmsd.d/
ADD limits.d/50-xrootd.conf /etc/security/limits.d/
ADD cron.d/* /etc/cron.d/
ADD bin/* /usr/local/sbin/*
ADD supervisord.d/* /etc/supervisord.d/
