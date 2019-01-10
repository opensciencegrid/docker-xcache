FROM centos:centos7

ADD hcc-testing.repo /etc/yum.repos.d/hcc-testing.repo
RUN yum -y install http://repo.opensciencegrid.org/osg/3.4/osg-3.4-el7-release-latest.rpm \
                   epel-release \
                   yum-plugin-priorities && \
    yum -y install xcache --enablerepo=osg-development && \
    yum -y install supervisor cronie
RUN yum clean all && rm -rf /var/cache/yum/

ADD cron.d/* /etc/cron.d/
ADD sbin/* /usr/local/sbin/
ADD supervisor/* /etc/

RUN mkdir -p /xrdpfc/stash && chown -R xrootd:xrootd /xrdpfc

RUN adduser ligo

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"] 