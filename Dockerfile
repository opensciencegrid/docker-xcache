FROM centos:centos7

RUN yum -y install http://repo.opensciencegrid.org/osg/3.4/osg-3.4-el7-release-latest.rpm && \
    yum -y install epel-release \
                   yum-plugin-priorities && \
    yum -y install stashcache-daemon stashcache-cache-server && \
    yum -y install lcmaps-plugins-scas-client xrootd-lcmaps globus-proxy-utils && \
    yum -y install fetch-crl cronie && \
    yum -y install emacs && \
    yum -y install supervisor

ADD fetch-crl-kubernetes /etc/cron.d/fetch-crl-kubernetes
ADD refresh-proxy /usr/local/sbin/refresh_proxy
ADD refresh_proxy.cron  /etc/cron.d/refresh_proxy.cron 

RUN mkdir -p /var/log/supervisor
ADD supervisord.conf /etc/supervisord.conf

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"] 