ARG BASE_YUM_REPO=testing

FROM opensciencegrid/xcache:$BASE_YUM_REPO

LABEL maintainer OSG Software <help@opensciencegrid.org>

ARG BASE_YUM_REPO=testing

ENV XC_IMAGE_NAME stash-cache

RUN if [[ $BASE_YUM_REPO = release ]]; then \
       yumrepo=osg-upcoming; else \
       yumrepo=osg-upcoming-$BASE_YUM_REPO; fi && \
    yum install -y --enablerepo=$yumrepo \
        stash-cache && \
    yum clean all --enablerepo=* && rm -rf /var/cache/

ADD cron.d/* /etc/cron.d/
RUN chmod 0644 /etc/cron.d/*
ADD supervisord.d/* /etc/supervisord.d/
ADD image-config.d/* /etc/osg/image-config.d/

# Add a placeholder authfile, incase this cache isn't registered
# and can't pull down a new one
ADD Authfile /run/stash-cache/Authfile
# Same for scitokens.conf
ADD scitokens.conf /run/stash-cache-auth/scitokens.conf

EXPOSE 8000

