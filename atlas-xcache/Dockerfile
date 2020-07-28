FROM opensciencegrid/xcache:fresh

LABEL maintainer OSG Software <help@opensciencegrid.org>

# Specify the base Yum repository to get the necessary RPMs
ARG BASE_YUM_REPO

ENV XC_IMAGE_NAME atlas-xcache

RUN yum install -y atlas-xcache --enablerepo="$BASE_YUM_REPO" --enablerepo=osg-contrib && \
    yum install -y python3 python3-requests && \
    yum clean all --enablerepo=* && rm -rf /var/cache/

COPY update-agis-status.sh /usr/local/sbin/
COPY update-cric-status.sh /usr/local/sbin/
COPY reporter.py stats.py /
COPY 10-atlas-xcache-limits.conf /etc/security/limits.d
COPY supervisord.d/10-atlas-xcache.conf /etc/supervisord.d/
COPY image-config.d/10-atlas-xcache.sh /etc/osg/image-config.d/
