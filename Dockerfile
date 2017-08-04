FROM ubuntu:16.04

# COPY firefox /usr/local/firefox

# Also install firefox to pull in all dependencies but move it so that
# the right version is the only runable one.

RUN apt-get -q update && \
    apt-get -qy dist-upgrade && \
    apt-get -qy install libterm-readline-perl-perl dialog && \
    apt-get -qy install sudo apt-utils software-properties-common xauth dialog

RUN apt-add-repository -y ppa:jonathonf/firefox-esr && \
    apt-get -q update && \
    apt-get -qy install firefox-esr

# Strangely this does not appear in firefox.  It does appear in firefox in ubuntu 17.04
RUN apt-get -qy install flashplugin-installer

RUN export uid=1000 gid=1000 && \
    mkdir -p /home/ffuser/.java/deployment/security/ && \
    mkdir -p /etc/sudoers.d && \
    echo "ffuser:x:${uid}:${gid}:Firefox user:/home/ffuser:/bin/bash" >> /etc/passwd && \
    echo "ffuser:x:${uid}:" >> /etc/group && \
    echo "ffuser ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/ffuser && \
    chmod 0440 /etc/sudoers.d/ffuser && \
    chown ${uid}:${gid} -R /home/ffuser

COPY exception.sites /home/ffuser/.java/deployment/security/

RUN echo debconf shared/accepted-oracle-license-v1-1 select true | \
    debconf-set-selections && \
    echo debconf shared/accepted-oracle-license-v1-1 seen true | \
    debconf-set-selections && \
    apt-add-repository -y ppa:webupd8team/java && \
    apt-get -q update && \
    apt-get -qy install oracle-java8-installer

# If java mysteriously is not present
# ln -s /usr/lib/jvm/java-8-oracle/jre/lib/amd64/libnpjp2.so /usr/lib/mozilla/plugins

USER ffuser
ENV HOME /home/ffuser
CMD /usr/bin/firefox

