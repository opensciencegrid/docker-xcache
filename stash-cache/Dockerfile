FROM opensciencegrid/xcache:latest

RUN yum -y install stash-cache --enablerepo=osg-minefield \
    osg-ca-generator && \
    yum clean all --enablerepo=* && rm -rf /var/cache/

ADD cron.d/* /etc/cron.d/
ADD supervisord.d/* /etc/supervisord.d/

# dev
RUN osg-ca-generator --host
RUN cp /etc/grid-security/{hostcert.pem,xrd/xrdcert.pem} && \
    cp /etc/grid-security/{hostkey.pem,xrd/xrdkey.pem}
RUN echo -e "set cachedir = $CACHEDIR\nset sitename = OSG\n" >> \
    /etc/xrootd/config.d/10-cache-site-local.cfg
