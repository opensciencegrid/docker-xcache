FROM centos:centos7

ADD hcc-testing.repo /etc/yum.repos.d/hcc-testing.repo
RUN yum -y install http://repo.opensciencegrid.org/osg/3.4/osg-3.4-el7-release-latest.rpm && \
    yum -y install epel-release \
                   yum-plugin-priorities && \
    yum -y install cronie && \
    yum -y install stashcache-cache-server --enablerepo=osg-testing && \
    yum -y install stashcache-cache-server-auth --enablerepo=osg-testing && \
    yum -y update xrootd* --enablerepo=hcc-testing && \
    yum -y install supervisor

ADD fetch-crl-kubernetes /etc/cron.d/fetch-crl-kubernetes
ADD refresh_proxy /usr/local/sbin/refresh_proxy
ADD fix_certs.sh /usr/local/sbin/fix_certs.sh
ADD refresh_proxy.cron  /etc/cron.d/refresh-proxy 
ADD grid-mapfile.ligo-cvmfs.py /usr/local/sbin/grid-mapfile.ligo-cvmfs.py
ADD generate_gridmap.cron /etc/cron.d/generate-gridmap

RUN mkdir -p /var/log/supervisor
ADD supervisord.conf /etc/supervisord.conf

RUN mkdir -p /xrdpfc/stash && chown -R xrootd:xrootd /xrdpfc

RUN adduser ligo

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"] 