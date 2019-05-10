FROM opensciencegrid/xcache:fresh

RUN yum -y install xrootd --enablerepo=osg-minefield
RUN yum -y install gperftools-libs

ADD xrootd/* /etc/xrootd/
ADD limits.d/50-xrootd.conf /etc/security/limits.d/
ADD cron.d/* /etc/cron.d/
ADD bin/* /usr/local/sbin/
ADD supervisord.d/* /etc/supervisord.d/

ENV XC_SITE UCSD-XCACHE
ENV XC_RAMSIZE 24g
ENV XC_SPACE_LOW_WM 0.95
ENV XC_SPACE_HIGH_WM 0.97
ENV XC_BLOCKSIZE 512k
ENV XC_PREFETCH 0
ENV XC_PORT 1094
ENV XC_ORIGIN cmsxrootd.fnal.gov:1094
ENV XC_DATA /data1/xcache
