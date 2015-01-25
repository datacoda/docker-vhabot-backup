FROM phusion/baseimage:0.9.16
MAINTAINER Ted Chen <ted@nephilagraphic.com>

# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Install packages required
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y wget \
        python python-dev python-pip librsync-dev \
        ncftp lftp rsync && \
    rm -rf /var/lib/apt/lists/*

# Install the pyhton requirements
ADD requirements.txt /opt/
RUN pip install --upgrade --requirement /opt/requirements.txt

# Download and install duplicity
RUN export VERSION=0.6.25 && \
    cd /tmp/ && \
    wget https://code.launchpad.net/duplicity/0.6-series/$VERSION/+download/duplicity-$VERSION.tar.gz && \
    cd /opt/ && \
    tar xzvf /tmp/duplicity-$VERSION.tar.gz && \
    rm /tmp/duplicity-$VERSION.tar.gz && \
    cd duplicity-$VERSION && \
    ./setup.py install && \
    rm -rf /tmp/* /var/tmp/*

# Exposed environments
ENV \
    SOURCE_DIR=/var/lib/vhabot/config.d \
    REMOTE_URL=s3+http://bucket/ \
    PASSPHRASE=symmetric \
    AWS_ACCESS_KEY_ID=secretid \
    AWS_SECRET_ACCESS_KEY=secretkey

ADD backup.sh /usr/local/bin/backup
ADD restore.sh /usr/local/bin/restore
ADD cron_backup.sh /usr/local/bin/cron_backup
ADD cron_daily.sh /etc/cron.daily/backup_incremental
ADD cron_weekly.sh /etc/cron.weekly/backup_full