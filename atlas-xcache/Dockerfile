ARG BASE_YUM_REPO=testing

FROM opensciencegrid/xcache:$BASE_YUM_REPO

LABEL maintainer OSG Software <help@opensciencegrid.org>

# Specify the base Yum repository to get the necessary RPMs
ARG BASE_YUM_REPO=testing

ENV XC_IMAGE_NAME atlas-xcache

RUN if [[ $BASE_YUM_REPO = release ]]; then \
       yumrepo=osg-upcoming; else \
       yumrepo=osg-upcoming-$BASE_YUM_REPO; fi && \
    yum install -y --enablerepo=$yumrepo --enablerepo=osg-contrib \
        atlas-xcache && \
    yum install -y python3 python3-psutil python3-requests && \
    yum clean all --enablerepo=* && rm -rf /var/cache/

COPY update-agis-status.sh /usr/local/sbin/
COPY update-cric-status.sh /usr/local/sbin/
COPY reporter.py stats.py /usr/local/sbin/
COPY 10-atlas-xcache-limits.conf /etc/security/limits.d
COPY supervisord.d/10-atlas-xcache.conf /etc/supervisord.d/
COPY image-config.d/10-atlas-xcache.sh /etc/osg/image-config.d/
