FROM opensciencegrid/xcache:fresh

RUN yum -y install xrootd --enablerepo=osg-minefield
RUN yum -y install gperftools-libs

ADD xrootd/* /etc/xrootd/
ADD limits.d/50-xrootd.conf /etc/security/limits.d/
ADD cron.d/* /etc/cron.d/
ADD bin/* /usr/local/sbin/
ADD supervisord.d/* /etc/supervisord.d/
