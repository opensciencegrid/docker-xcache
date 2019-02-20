FROM centos:centos7

RUN yum -y install http://repo.opensciencegrid.org/osg/3.4/osg-3.4-el7-release-latest.rpm \
                   epel-release \
                   yum-plugin-priorities && \
    yum -y install xcache --enablerepo=osg-minefield && \
    yum -y install supervisor cronie && \
    yum -y install stash-origin --enablerepo=osg-development && \
    yum clean all --enablerepo=* && rm -rf /var/cache/yum/

ADD cron.d/* /etc/cron.d/
ADD sbin/* /usr/local/sbin/
ADD supervisord.conf /etc/
ADD supervisord.d/* /etc/supervisord.d/

ADD dummy_pod_init.sh /usr/bin/pod_init.sh
ADD supervisord_startup.sh /usr/bin/supervisord_startup.sh

CMD ["/usr/bin/supervisord_startup.sh"]

