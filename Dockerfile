FROM ubuntu:16.04

COPY firefox /usr/local/firefox

# Also install firefox to pull in all dependencies but move it so that
# the right version is the only runable one.

RUN apt-get -q update && \
    apt-get -qqy dist-upgrade && \
    apt-get -qqy install sudo apt-utils libterm-readline-perl-perl \
    	    software-properties-common xauth x11-apps firefox \
	    desktop-file-utils && \
    mv /usr/bin/firefox /usr/bin/firefox-54 && \
    ln -s /usr/local/firefox/firefox /usr/bin

RUN apt-get -qqy install flashplugin-installer

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
    apt-add-repository ppa:webupd8team/java && \
    apt-get update && \
    apt-get -qy install oracle-java8-installer && \
    ln -s /usr/lib/jvm/java-8-oracle/jre/lib/amd64/libnpjp2.so /usr/lib/mozilla/plugins

USER ffuser
ENV HOME /home/ffuser
CMD /usr/local/firefox/firefox
