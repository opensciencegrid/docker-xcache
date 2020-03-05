FROM opensciencegrid/xcache:fresh

LABEL maintainer OSG Software <help@opensciencegrid.org>

RUN yum -y install stash-cache --enablerepo=osg-testing && \
    yum clean all --enablerepo=* && rm -rf /var/cache/

ADD cron.d/* /etc/cron.d/
RUN chmod 0644 /etc/cron.d/*
ADD supervisord.d/* /etc/supervisord.d/
ADD image-config.d/* /etc/osg/image-config.d/

# Add a placeholder authfile, incase this cache isn't registered
# and can't pull down a new one
ADD Authfile /run/stash-cache/Authfile

EXPOSE 8000

