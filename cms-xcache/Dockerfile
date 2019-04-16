FROM opensciencegrid/xcache:development

RUN yum -y install xrootd --enablerepo=osg-minefield
RUN yum -y install gperftools-libs

ADD xrootd/* /etc/xrootd/
ADD limits.d/50-xrootd.conf /etc/security/limits.d/50-xrootd.conf
ADD grid-security/cache_cert /etc/grid-security/cache_cert
ADD cron.d/* /etc/cron.d/
ADD bin/move_core /usr/local/sbin/move_core
ADD bin/refresh_proxy /usr/local/sbin/refresh_proxy
ADD systemd/* /etc/systemd/
