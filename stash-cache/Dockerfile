FROM opensciencegrid/xcache:development

LABEL maintainer OSG Software <help@opensciencegrid.org>

RUN yum -y install stash-cache --enablerepo=osg-minefield \
    osg-ca-generator && \
    yum clean all --enablerepo=* && rm -rf /var/cache/

ADD cron.d/* /etc/cron.d/
ADD supervisord.d/* /etc/supervisord.d/
ADD stash-cache-init.sh /usr/local/sbin/

# Add a placeholder authfile, incase this cache isn't registered
# and can't pull down a new one
ADD Authfile /run/stash-cache/Authfile

EXPOSE 8000

