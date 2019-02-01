FROM opensciencegrid/xcache:development

LABEL maintainer OSG Software <help@opensciencegrid.org>

RUN yum -y install stash-cache --enablerepo=osg-minefield \
    osg-ca-generator && \
    yum clean all --enablerepo=* && rm -rf /var/cache/

ADD cron.d/* /etc/cron.d/
ADD supervisord.d/* /etc/supervisord.d/
ADD stash-cache-init.sh /usr/local/sbin/

